Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60929 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbZA0JqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 04:46:17 -0500
Message-ID: <497ED7DD.9010102@lwfinger.net> (sfid-20090127_104620_976031_C97A8FD8)
Date: Tue, 27 Jan 2009 03:46:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: John W Linville <linville@tuxdriver.com>, barreyromartin@gmail.com,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix error in setting OFDM power settings for
 RTL8187L
References: <117528.49182.qm@web23104.mail.ird.yahoo.com>
In-Reply-To: <117528.49182.qm@web23104.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> --- On Tue, 27/1/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> After reports of poor performance, a review of the latest
>> vendor driver
>> (rtl8187_linux_26.1025.0328.2007) for RTL8187L devices was
>> undertaken.
>>
>> A difference was found in the code used to index the OFDM
>> power tables. When
>> the Linux driver was changed, my unit works at a much
>> greater range than
>> before. I think this fixes Bugzilla #12380 and has been
>> tested by at least
>> two other users.
> 
> What exactly does this change do? it seems to just bias the value of ofdm into higher values:
> 
> 0-15 -> 10-25
> 15-  -> 25

The values of ofdm_power and cck_power are indexes into the tables
rtl8225_tx_power_cck or rtl8225z2_tx_power_cck. The change does bias
the value into larger numbers both for the index and the value in the
table. Whatever happens inside the device, the bottom line is that the
OFDM performance is greatly improved, at least for the units that use
the rtl8225z2_tx_power_cck table. I'm not sure that any of the other
type have been encountered.

After my experiences with the RTL8187B, I was careful to monitor the
device temperature. Although it is likely that this change increased
the power output of the radio, the device did not get any hotter.

> Also, the first "ofdm_power = min(ofdm_power, (u8)35);" after the change chunk has no effect, since the value from the changed code would clip at 25. You could remove that line...

Thank you for seeing that. I'll submit a revised patch.

Larry
