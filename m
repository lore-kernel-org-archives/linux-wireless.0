Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35778 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932411AbcLNQSO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 11:18:14 -0500
Received: by mail-qk0-f169.google.com with SMTP id n204so26474638qke.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2016 08:18:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161214155743.GA22282@animalcreek.com>
References: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
 <20160422000119.GA21754@animalcreek.com> <20161213220545.GA29317@animalcreek.com>
 <CAO7Z3WJwf80mCqubSYTeK=BHN9sd=mzmL9th4Su-E25de6TmAg@mail.gmail.com> <20161214155743.GA22282@animalcreek.com>
From: Geoff Lansberry <geoff@kuvee.com>
Date: Wed, 14 Dec 2016 11:17:33 -0500
Message-ID: <CAO7Z3WKqhS5Q6qAaDs8364KP5-7ma=b_ic2B10=njngMmp5noQ@mail.gmail.com> (sfid-20161214_171831_957017_AF64A5FE)
Subject: Re: [Patch] NFC: trf7970a:
To: Mark Greer <mgreer@animalcreek.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Justin Bronder <justin@kuvee.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2016 at 10:57 AM, Mark Greer <mgreer@animalcreek.com> wrote:
>
> On Tue, Dec 13, 2016 at 08:50:04PM -0500, Geoff Lansberry wrote:
> > Hi Mark -  Thanks for getting back to me.   It's funny that you ask,
> > because we are currently chasing a segfault that is happening in neard, but
> > may end up back in the trf7970a driver.   Have you ever heard on anyone
> > having segfault problems related to the trf7970a hardware drivers?
>
> No.  Mind sharing more info on that segfault?
>
> > I'll get you an update later tonight or tomorrow.
>
> Okay, thanks.
>
> Mark
> --

Mark - The segfault issue is only happening on writing, The work on
the segfault is being done by a consultant, but here is his statement
on how to recreate it on our build:

I am able to reliably force neard to segfault by flooding it with
write requests. I have attached a python script called flood.py that
can be used to do this. The script uses utilities that ship with
neard.

The segfault does not appear deterministic. It usually happens within
1000 writes, but the time can varying greatly. The logs output from
neard are inconsistent between crashes, which suggests this may be a
timing or race condition related issue.

I have been running neard manually to obtain the log information and a
core file for debugging (attached). I run neard as,

  $ /usr/lib/neard/nfc/neard -d -n

In a separate terminal I run,

  $ python flood.py

And the resulting core file provides the following backtrace,

(gdb) bt
#0  0xb6caed64 in ?? ()
#1  0x0001ed7c in data_recv (resp=0x5bd90 "", length=17, data=0x58348)
at plugins/nfctype2.c:156
#2  0x00024ecc in execute_recv_cb (user_data=0x5bd88) at src/adapter.c:979
#3  0xb6e70d60 in ?? ()
Backtrace stopped: previous frame identical to this frame (corrupt stack?)
(gdb)

The line at nfctype2.c:156 contains a memcpy operation.


Below is the flood.py script:
#!/usr/bin/python

import neardutils
import dbus
import time

bus = dbus.SystemBus()
DURATION = 0.05


def write():
    # Get an adapter interface
    objects = neardutils.get_managed_objects()
    for path, interfaces in objects.iteritems():
        if "org.neard.Adapter" in interfaces:
            break

    else:
        raise Exception("Unable to find adapter")

    print("adapter object path: " + path)
    adapter = dbus.Interface(bus.get_object("org.neard", path),
"org.freedesktop.DBus.Properties")

    # power cycle
    try:
        adapter.Set("org.neard.Adapter", "Powered", dbus.Boolean(0))
        time.sleep(DURATION)
    except:
        pass

    try:
        adapter.Set("org.neard.Adapter", "Powered", dbus.Boolean(1))
        time.sleep(DURATION)
    except:
        pass

    # Set polling
    adapter = dbus.Interface(bus.get_object("org.neard", path),
"org.neard.Adapter")
    adapter.StartPollLoop("Initiator")

    time.sleep(DURATION)

    # write tag
    objects = neardutils.get_managed_objects()
    for path, interfaces in objects.iteritems():
        if "org.neard.Tag" in interfaces:
            break
    else:
        raise Exception("Unable to find tag")

    print("tag object path: " + path)

    time.sleep(DURATION)

    tag = dbus.Interface(bus.get_object("org.neard", path), "org.neard.Tag")
    tag.Write(({
        "Type": "Text",
        "Encoding": "UTF-8",
        "Language": "en",
        "Representation": "omen_red_2014",
        }))

    time.sleep(DURATION)

    objects = neardutils.get_managed_objects()
    for path, interfaces in objects.iteritems():
        if "org.neard.Record" in interfaces:
            break
    else:
        raise Exception("Unable to read record")

    print("record object path: " + path)

    time.sleep(DURATION)

    record = dbus.Interface(bus.get_object("org.neard", path),
"org.freedesktop.DBus.Properties")
    print("representation: " + record.Get("org.neard.Record", "Representation"))


def main():
    for iteration in range(1000):
        try:
            print("==================================================")
            print("iteration: " + str(iteration))
            write()
            print("SUCCESS")

        except Exception,e:
            print(str(e))
            print("FAILURE")


if __name__ == "__main__":
    main()
-----

If we find the source of the problem, we will share it upstream.   If
you have any thoughts on where to look, please share.

Geoff Lansberry
