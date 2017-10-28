Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdJ1PS6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Oct 2017 11:18:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 12/12] wil6210: update statistics for suspend
References: <1508937247-11890-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1508937247-11890-13-git-send-email-qca_merez@qca.qualcomm.com>
Date: Sat, 28 Oct 2017 18:18:54 +0300
In-Reply-To: <1508937247-11890-13-git-send-email-qca_merez@qca.qualcomm.com>
        (Maya Erez's message of "Wed, 25 Oct 2017 16:14:07 +0300")
Message-ID: <87k1zfs3kx.fsf@purkki.adurom.net> (sfid-20171028_171918_140556_F60E9ABE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> writes:

> From: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
>
> Currently the statistics show how many successful/failed
> suspend/resume operations the system had.
> Update the statistics by splitting each successful/failed
> suspend/resume operations to radio on/off.
>
> Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c  | 27 ++++++++++++++++++---------
>  drivers/net/wireless/ath/wil6210/pcie_bus.c | 20 ++++++++++++++------
>  drivers/net/wireless/ath/wil6210/pm.c       |  8 +++++---
>  drivers/net/wireless/ath/wil6210/wil6210.h  | 11 ++++++++---
>  4 files changed, 45 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> index 03d17ea..9164855 100644
> --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> @@ -1685,20 +1685,29 @@ static ssize_t wil_read_suspend_stats(struct file *file,
>  				      size_t count, loff_t *ppos)
>  {
>  	struct wil6210_priv *wil = file->private_data;
> -	static char text[400];
> +	static char text[500];

I was first about to mention about excessive stack usage but only then I
noticed the static keyword. That again is problematic when you have two
(or more) devices as then they would be accessing the same buffer,
right?

As this from debugfs interface I admit that it's a very theoretical
issue but still something which should be fixed. I can still take this
patch, but please fix the static usage in a followup patch.

-- 
Kalle Valo
