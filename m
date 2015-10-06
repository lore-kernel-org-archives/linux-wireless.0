Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:32775 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbbJFXLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 19:11:46 -0400
Date: Wed, 7 Oct 2015 00:11:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jacob Kiefer <jtk54@cornell.edu>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"open list:STAGING - REALTEK RTL8723U WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] staging: rtl8723au: Fix sparse errors in
 rtl8723a_cmd.c
Message-ID: <20151006231134.GV22011@ZenIV.linux.org.uk> (sfid-20151007_011205_415246_4384E8F0)
References: <1444105958-32087-1-git-send-email-jtk54@cornell.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444105958-32087-1-git-send-email-jtk54@cornell.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2015 at 12:32:28AM -0400, Jacob Kiefer wrote:

>  int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
>  {
> -	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
> +	__le32 leparam;
> 
> -	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
> +	leparam = cpu_to_le32(*((u32 *)param));
> +
> +	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&leparam);

Why not fill the thing we are passing already with little-endian?  There's
only one caller, after all...

>  int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
>  {
>  	u8 buf[5];
> +	__le32 lemask;
> 
>  	memset(buf, 0, 5);
> -	mask = cpu_to_le32(mask);
> -	memcpy(buf, &mask, 4);
> +	lemask = cpu_to_le32(mask);
> +	memcpy(buf, &lemask, 4);
>  	buf[4]  = arg;
> 
>  	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);

Ugh...
	struct macid_config_eid {__le32 mask; u8 arg;} buf = {
		.mask = cpu_to_le32(mask), .arg = arg
	};

	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, &buf);

Why bother with memcpy/memset/whatnot when all you are trying to do is to
initialize a temporary structure?  And no, it's not going to have any gaps...
