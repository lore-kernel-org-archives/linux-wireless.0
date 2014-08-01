Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:62747 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaHAOq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2014 10:46:27 -0400
Message-ID: <53DBA840.6050804@lwfinger.net> (sfid-20140801_164644_192267_3EBA1954)
Date: Fri, 01 Aug 2014 09:46:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Miguel Oliveira <cmroliv@gmail.com>, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix static symbol sparse warning
References: <1406898387-13987-1-git-send-email-cmroliv@gmail.com>
In-Reply-To: <1406898387-13987-1-git-send-email-cmroliv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2014 08:06 AM, Miguel Oliveira wrote:
> Fix sparse warning:
> drivers/staging/rtl8723au/core/rtw_efuse.c:579:5: warning: symbol 'efuse_GetCurrentSize23a' was not declared. Should it be static?
> 
> Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
> ---
>  drivers/staging/rtl8723au/include/rtw_efuse.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/rtl8723au/include/rtw_efuse.h b/drivers/staging/rtl8723au/include/rtw_efuse.h
> index 07bdc34..304cc71 100644
> --- a/drivers/staging/rtl8723au/include/rtw_efuse.h
> +++ b/drivers/staging/rtl8723au/include/rtw_efuse.h
> @@ -82,6 +82,7 @@ struct pg_pkt_struct {
>  /*------------------------Export global variable----------------------------*/
>  
>  u16	efuse_GetMaxSize23a(struct rtw_adapter *padapter);
> +int	efuse_GetCurrentSize23a(struct rtw_adapter *padapter, u16 *size);
>  int	rtw_efuse_access23a(struct rtw_adapter *padapter, u8 bRead, u16 start_addr, u16 cnts, u8 *data);
>  int	rtw_efuse_map_read23a(struct rtw_adapter *padapter, u16 addr, u16 cnts, u8 *data);
>  u8	rtw_efuse_map_write(struct rtw_adapter *padapter, u16 addr, u16 cnts, u8 *data);

NACK. Whenever Sparse issues this warning, you should first check to see if it
can be made static. Adding it to a header to make the Sparse warning go away is
not correct unless some other routine needs it to be globally known. In this
case, no other routine needs it.

Of course, making it static will lead to the compilation warning that the
routine is not used. The correct patch is to delete the entire routine as it is
never called.

Larry


