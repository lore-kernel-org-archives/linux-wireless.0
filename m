Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42039 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab0LATzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 14:55:01 -0500
Received: by vws16 with SMTP id 16so620217vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 11:55:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF69ED1.1070406@lwfinger.net>
References: <4CF69ED1.1070406@lwfinger.net>
Date: Wed, 1 Dec 2010 20:55:00 +0100
Message-ID: <AANLkTin7RkTWggXFoKaqEX7L2MjUKu1OLXFb5NF_BEXR@mail.gmail.com>
Subject: Re: RFC - removal of SPROM fallback
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/1 Larry Finger <Larry.Finger@lwfinger.net>:
> At one time, we thought that we had found BCM43xx devices with no SPROM. In the
> one case that I remember, it was because the SPROM had been relocated.

That's right.


> I now have the data from John's device that needs the revision fixup and I know
> what is wrong - it is rev 2 with corrupted CRC. The defaulting to rev 1 is
> getting almost everything wrong, including MAC address and vendor. My plan is to
> write a better fixup routine.

That's interesting... so is that SPROM rev2 with CRC counted like for
rev1? Are you sure about this case? AFAIR:
1) John got CRC error when we dropped hack and treated SPROM as
revision it reports
2) John got success CRC check when we hacked his SPROM to "be" rev 1


> At the moment, we have some SPROM fallback code that has not been fully
> implemented, and is probably not needed. Are there any objections to stripping
> this code out of drivers/ssb/pci.c and drivers/ssb/sprom.c?

I don't believe we will find out SSBs without SPROMs and implementing
support for new Broadcom cards should not depend on SSB code... so I
do not any problems about that.


-- 
Rafał
