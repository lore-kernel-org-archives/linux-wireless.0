Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:35042 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYLDM47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 07:56:59 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
Date: Thu, 4 Dec 2008 13:57:00 +0100
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W Linville" <linville@tuxdriver.com>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
References: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net> <69e28c910812040444l5d76632ah288078bd3db172d4@mail.gmail.com>
In-Reply-To: <69e28c910812040444l5d76632ah288078bd3db172d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200812041357.00103.chunkeey@web.de> (sfid-20081204_135706_164632_A312A0C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 04 December 2008 13:44:09 Stefanik G=E1bor wrote:

> BTW using RTL8187B's scaling constants for RTL8187L also work well
> with this patch - I get almost identical readings from my BCM4318 and
> my RTL8187L. (I haven't yet submitted my version of the patch because
> it's pretty messy, with #if 0'd code and such.) I wonder whether b43
> or p54usb is more correct... However, it looks like the same algorith=
m
> is applicable for both RTL8187 variants.
>=20
probably b43. p54usb uses static scaling constants to calculate
signal & noise dbm, instead of finding the correct values from the devi=
ce eeprom
(Note: Link Quality doesn't substract the noise so it could be off even=
 more).

However, in my testing it was only a few +/- dbm(s), what's your readin=
g?
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
