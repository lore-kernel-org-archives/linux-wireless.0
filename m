Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbbJDIsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 04:48:12 -0400
Date: Sun, 4 Oct 2015 09:48:08 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jacob Kiefer <jtk54@cornell.edu>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"open list:STAGING - REALTEK RTL8723U WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	open list <linux-kernel@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au: Fix Sparse errors in rtl8723a_cmd.c
Message-ID: <20151004084808.GA30827@kroah.com> (sfid-20151004_104837_733709_94F38F5C)
References: <1443832594-29663-1-git-send-email-jtk54@cornell.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443832594-29663-1-git-send-email-jtk54@cornell.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 08:36:28PM -0400, Jacob Kiefer wrote:
> From: Jacob Kiefer <jtk54@cornell.edu>
> 
> This patch fixes the following sparse errors:
> 
> 
>   CHECK   drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> ...
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25: warning: incorrect type in assignment (different base types)
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25:    expected unsigned int [unsigned] [usertype] <noident>
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:118:25:    got restricted __le32 [usertype] <noident>
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14: warning: incorrect type in assignment (different base types)
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14:    expected unsigned int [unsigned] [usertype] mask
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:130:14:    got restricted __le32 [usertype] <noident>
>   CC [M]  drivers/staging/rtl8723au/hal/rtl8723a_cmd.o
> 
> Signed-off-by: Jacob Kiefer <jtk54@cornell.edu>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> index 9733aa6..111a24d 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> @@ -115,9 +115,11 @@ exit:
>  
>  int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
>  {
> -	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
> +	__le32 leparam;

Why __le32?  Does this variable go across the user/kernel boundry
somehow?  If not, just use le32.

>  
> -	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
> +	leparam = cpu_to_le32(*((u32 *)param));
> +
> +	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&leparam);

At first glance, you aren't doing ths same logic in this function as the
original did, please look at this very closely again and verify that you
are doing this correctly.

Don't just blindly quiet tools like sparse, it is warning for a reason,
but be careful about your fix.

thanks,

greg k-h
