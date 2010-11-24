Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36456 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0KXKSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 05:18:45 -0500
Received: by gwj20 with SMTP id 20so658901gwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 02:18:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290592288.3790.12.camel@jlt3.sipsolutions.net>
References: <1290591333-30453-1-git-send-email-eliad@wizery.com>
	<1290592192.3790.11.camel@jlt3.sipsolutions.net>
	<1290592288.3790.12.camel@jlt3.sipsolutions.net>
Date: Wed, 24 Nov 2010 12:18:44 +0200
Message-ID: <AANLkTinAEN=OUpXP3V0exw_EuU+cq8Vm_G0F_zdHEMzV@mail.gmail.com>
Subject: Re: [PATCH] wl1271: use debugfs_remove_recursive
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 11:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-11-24 at 10:49 +0100, Johannes Berg wrote:
>> On Wed, 2010-11-24 at 11:35 +0200, Eliad Peller wrote:
>>
>> > @@ -524,23 +423,14 @@ int wl1271_debugfs_init(struct wl1271 *wl)
>> >  {
>> >     int ret;
>> >
>> > -   wl->debugfs.rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
>> > +   wl->rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
>> >
>> > -   if (IS_ERR(wl->debugfs.rootdir)) {
>> > -           ret = PTR_ERR(wl->debugfs.rootdir);
>> > -           wl->debugfs.rootdir = NULL;
>> > +   if (IS_ERR(wl->rootdir)) {
>> > +           ret = PTR_ERR(wl->rootdir);
>> > +           wl->rootdir = NULL;
>> >             goto err;
>> >     }
>>
>> This looks problematic if you ever have more than one device ... I
>> suggest moving to using the wiphy's debugfs dir as the parent for the
>> rootdir.
>
> But of course, that comment is entirely unrelated to _this_ patch.
>
good point.
i'll take care of it and send it as a new patch series.

Eliad.
