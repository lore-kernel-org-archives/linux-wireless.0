Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:49606 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab3B1XKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 18:10:42 -0500
Received: by mail-lb0-f182.google.com with SMTP id gg6so1817278lbb.27
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2013 15:10:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABvG-CWsvuJzMp06BitK1RGF55WJjZ8O4H58=VRpMcX27362RA@mail.gmail.com>
References: <1361992172-4590-1-git-send-email-kazikcz@gmail.com>
 <CAJ-Vmo=2==jGr-xWL8As7qvJs0YDWe2DekVCwEY2sQSsXtrL0w@mail.gmail.com> <CABvG-CWsvuJzMp06BitK1RGF55WJjZ8O4H58=VRpMcX27362RA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 28 Feb 2013 15:10:21 -0800
Message-ID: <CAB=NE6VBLQTtcT6rAQ===GFxSai6-+O=Ms7mMRhG4mB0pAc3Qw@mail.gmail.com> (sfid-20130301_001045_987397_F0DCCE87)
Subject: Re: [PATCH v2] ath: sanitize 0xFFFF regdomain
To: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2013 at 10:52 PM, Michał Kazior <kazikcz@gmail.com> wrote:
> On 28 February 2013 03:43, Adrian Chadd <adrian@freebsd.org> wrote:
>> Have you verified that the rest of the EEPROM contents are vailid?
>
> I have not. How can I do that?

The module would have done this upon initialization, this is done
during hw init, prior to reg init. The EEPROM callback fill_eeprom()
does this for the different families. To be clear ath9k_hw_init() gets
called prior to ath_regd_init().

I'll note for the record that regardless of what is decided if the
card came from a device designed as an AP the AP manufacturer intended
for that card to stay with that AP, and as per our support team the AP
design / manufacturer could end up programming whatever into the
EEPROM / OTP, and their support for that device would be intended with
their own solution.

Supporting 0x64 for this regdomain that some random AP manufacturer
used should be OK though but note that we can't support it.

  Luis
