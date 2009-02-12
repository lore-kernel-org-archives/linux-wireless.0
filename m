Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:46554 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZBLIkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 03:40:24 -0500
Received: by fxm13 with SMTP id 13so1610857fxm.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 00:40:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090212092658.1ad4bb08.cjsthompson@gmail.com>
References: <20090211211707.d5e71ddb.cjsthompson@gmail.com>
	 <200902112332.53480.IvDoorn@gmail.com>
	 <3ace41890902111451n6c9cbdc4me410609479b1ac4f@mail.gmail.com>
	 <20090212042217.b05e83b4.cjsthompson@gmail.com>
	 <a32f33a40902120000g1e95df1eq8a221ddc539f351c@mail.gmail.com>
	 <20090212092658.1ad4bb08.cjsthompson@gmail.com>
Date: Thu, 12 Feb 2009 09:40:22 +0100
Message-ID: <a32f33a40902120040odc535cp3ecdeef3bc9565ab@mail.gmail.com> (sfid-20090212_094029_263010_96637802)
Subject: Re: Sitecom WL-608 USB WiFi
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "Christoph .J Thompson" <cjsthompson@gmail.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 9:26 AM, Christoph .J Thompson
<cjsthompson@gmail.com> wrote:
> On Thu, 12 Feb 2009 09:00:27 +0100
> Ivo Van Doorn <ivdoorn@gmail.com> wrote:
>
>> On Thu, Feb 12, 2009 at 4:22 AM, Christoph .J Thompson
>> Hmm thats weird, I couldn't find the reference that it is a 11n device. :S
>> Anyway, I'll add the USB ID to rt2800usb.
>>
>> Ivo
>
> What tiped me was that the string 2870 could be found in the MacOS X dmg driver file name available for download for this WL-608 card on Sitecom's website. So I guess my dreams of Access Point are over now :s By any chance, could you recommend a small form factor USB WiFi dongle that works for that purpose?

As far as I know the rt2870 driver provided by Ralink contains support
for Master mode, and it should even cooperate with hostapd. Not sure
if anybody has tested that yet. But you could give it a try. Otherwise
you can check rt2x00.git to see if the rt2800usb driver can send out
beacons correctly. So far I have only tested managed mode and that
worked reasonable (if you ignore the lack of 11n AP scan results, and
some startup kickups). Note that you should use the module parameter
nohwcrypt for rt2800usb to disable HW crypto.

Ivo
