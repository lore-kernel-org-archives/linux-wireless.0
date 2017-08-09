Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:38117 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbdHIICc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 04:02:32 -0400
Received: by mail-wr0-f171.google.com with SMTP id f21so20995996wrf.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Aug 2017 01:02:31 -0700 (PDT)
Subject: Re: [PATCH v4 01/10] wil6210: protect against invalid length of tx
 management frame
To: Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1501787302-22885-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1501787302-22885-2-git-send-email-qca_merez@qca.qualcomm.com>
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Lior David <qca_liord@qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <598AC195.3000205@broadcom.com> (sfid-20170809_100236_716822_84DD6457)
Date: Wed, 9 Aug 2017 10:02:29 +0200
MIME-Version: 1.0
In-Reply-To: <1501787302-22885-2-git-send-email-qca_merez@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/3/2017 9:08 PM, Maya Erez wrote:
> From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
>
> Validate buffer length has the minimum needed size
> when sending management frame to protect against
> possible buffer overrun.

I noticed this is already applied, but I saw this subject text which has 
similar sound to a recent patch in our driver so I it made me curious...

> Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/wil6210/cfg80211.c | 3 +++
>   drivers/net/wireless/ath/wil6210/debugfs.c  | 3 +++
>   2 files changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
> index 0b5383a..77af749 100644
> --- a/drivers/net/wireless/ath/wil6210/cfg80211.c
> +++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
> @@ -884,6 +884,9 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>   	wil_hex_dump_misc("mgmt tx frame ", DUMP_PREFIX_OFFSET, 16, 1, buf,
>   			  len, true);
>
> +	if (len < sizeof(struct ieee80211_hdr_3addr))
> +		return -EINVAL;

A similar check is already in net/wireless/cfg80211_mlme_mgmt_tx() which 
calls this function:

	if (params->len < 24 + 1)
		return -EINVAL;

So it only makes sense if this is called from some other call site....

>   	cmd = kmalloc(sizeof(*cmd) + len, GFP_KERNEL);
>   	if (!cmd) {
>   		rc = -ENOMEM;
> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> index f82506d..a2b5d59 100644
> --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> @@ -801,6 +801,9 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
>   	int rc;
>   	void *frame;
>
> +	if (!len)
> +		return -EINVAL;
> +

... which is in this function. Now I wonder why you would need this 
method in the first place. Why not stick with using the nl80211 
NL80211_CMD_FRAME api?

Regards,
Arend

>   	frame = memdup_user(buf, len);
>   	if (IS_ERR(frame))
>   		return PTR_ERR(frame);
>
