Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57788 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2GGE43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 00:56:29 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so16245990obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 21:56:28 -0700 (PDT)
Date: Fri, 6 Jul 2012 23:56:25 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
Message-ID: <20120707045624.GE3574@burratino> (sfid-20120707_065633_333923_7E534B04)
References: <CAKprTDGtvUFSBb_XK01bi6bJa3dynu73Lq-jTs=E78E3QwSqpA@mail.gmail.com>
 <20120601174237.GA31781@burratino>
 <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino>
 <4FE0CA49.3030909@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4FE0CA49.3030909@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Arend van Spriel wrote:
> On 06/11/2012 05:15 AM, Jonathan Nieder wrote:

>> Newer kernels seemed to work better than old, so I asked her to apply
>> the following patches agains the 3.2.y tree (the exact patches used
>> are at [2]):

I asked Camaleón to test the collection again to rule out a fluke.
Still looks ok[1]:

|                      I've been running this test (kernel 3.2.21 with 
| all the patches applied) since last Saturday which has been running 
| quite stable (only a couple reconnects in 7 days

Phew.

[...]
> My hunch based on what I found so far is that the patches mentioning the
> word 'mute' could be key here.

Unfortunately a collection including all of those (patches 1-10)
produces lots of reconnects and gnome-shell segfaults:

| Applied the ten first patches, compiled 3.2.21-1 from Debian sources
| and... well, I'm attaching log.

[...]
> I really need to dive into the patches individually so it may take some
> time.

Thanks.

Camaleón also tried changing the regulatory domain:

| >> I can try Arend's suggestion of setting "US" for the CRDA instead ES :-?
| >
| > This would be interesting, too (as an independent test).
|
| I tried but got no successful results so I restored the ES setting.

If you have questions for Camaleón or tests that it would be useful to
run, I'm all ears.  Unless we hear from you, the next test will
probably be to try patches 1-17, to cut the list of patches that might
have fixed it in half.

Ciao,
Jonathan

[1] http://bugs.debian.org/664767
