Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbcADPrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 10:47:11 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Sven Dziadek <sven.dziadek@gmx.de>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] staging: rtl8723au: fix byte order problems
References: <1451921374-471-1-git-send-email-sven.dziadek@gmx.de>
Date: Mon, 04 Jan 2016 10:47:10 -0500
In-Reply-To: <1451921374-471-1-git-send-email-sven.dziadek@gmx.de> (Sven
	Dziadek's message of "Mon, 4 Jan 2016 16:29:34 +0100")
Message-ID: <wrfjlh85s5xd.fsf@redhat.com> (sfid-20160104_164728_454920_B43BB2E6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Dziadek <sven.dziadek@gmx.de> writes:
> Remove byte order conversions.
> Conversion is already done in usb_ops_linux.c when accessing usb port.
> The deleted lines convert to little-endian and then call FillH2CCmd to
> convert back. Additionally, they are applied to wrong types and
> process wrong parts of variables later on.
>
> Signed-off-by: Sven Dziadek <sven.dziadek@gmx.de>
> ---
>
> I was looking for some Sparse warnings that I could fix and found this:
>
> drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:96:38: warning: cast to
> restricted __le16
> drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:100:27: warning: cast to
> restricted __le32
> drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:118:25: warning: incorrect
> type in assignment (different base types)
> drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:118:25:    expected
> unsigned int [unsigned] [usertype] <noident>
> drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:118:25:    got restricted
> __le32 [usertype] <noident>
>
> The rtl8723au drivers seems to work on many machines already, but
> probably mostly on little-endian machines.
> The file staging/rtl8723au/hal/rtl8723a_cmd.c contains four conversions
> from or to little-endian that look suspicious.
> The best example is:
>
> int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
> {
> 	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
>
> 	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
>
> 	return _SUCCESS;
> }
>
> On little-endian, the conversion does nothing, but on big-endian, it
> swaps the order and then only 3 bytes are used in FillH2CCmd (3rd
> argument). So it actually ignores the original argument param.
>
> I think it is best to delete these conversions because the actual
> conversions are done when transferring data to or from the usb port already.
>
> Unfortunately, I do not have the hardware to test it.
> What do you think about the patch?

Be *very* careful with this - there is a lot of dodgy passing back and
forth to the hardware and the format needs to match what the firmware
expects.

Unless you are going to test this and confirm that it actually works,
then please stay away from this.

NAK

Thanks,
Jes
