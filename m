Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab0JAFnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 01:43:01 -0400
Received: by fxm14 with SMTP id 14so415255fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 22:42:58 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <JoshuaESmith@charter.net>
Subject: Re: Question about starting up an AP
Date: Fri, 1 Oct 2010 07:42:07 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, Ivo van Doorn <ivdoorn@gmail.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <71135D34-18F6-4909-A8AB-E7390FA73049@charter.net> <201009301814.47318.helmut.schaa@googlemail.com>
In-Reply-To: <201009301814.47318.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010010742.07605.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joshua,

Am Donnerstag 30 September 2010 schrieb Helmut Schaa:
> Am Donnerstag 30 September 2010 schrieb Joshua Smith:
> > I think I have a clue about the WPDMA TX/RX busy bug.  I was having trouble
> > using the latest compat-wireless with USB dongle I have (ID AB50:2019
> > rt73usb), so I tried rolling Helmut's "oops" fix into:
> > 
> > compat-wireless-2010-07-15
> > 
> > which I have been using successfully for the last few months.  Lo and behold,
> > this version does *NOT* exhibit the TX/RX busy error.  So whatever is causing
> > that problem was introduced between 7/15/2010 and 9/20/2010.
> 
> Thanks for the analysis Joshua! Since this is a regression I guess we
> should try to find out quickly which commit introduced it (and fix it up
> of course) ...

Unfortunately during that time a lot of rt2x00 patches went into
wireless-testing. However, there's one suspicious commit that touches the
relevant code: "rt2x00: Merge rt2800{pci/usb} radio enabling/disabling code
to rt2800lib".

This is again a shot in the dark but worth a try. Could you please revert this
commit [1] from the newer compat-wireless tarball and try if it fixes the "DMA
Busy" issue?

Thanks Joshua,
Helmut

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=b9a07ae9d9e09662013992088fd58ffbcb2f9a30
