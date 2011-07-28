Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56498 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1G1VLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 17:11:53 -0400
Received: by qwk3 with SMTP id 3so1550849qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 14:11:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Jul 2011 14:11:32 -0700
Message-ID: <CAB=NE6WfMgGQCzWUtdnA70w-u9agG8SS-W=JKL1V0nL8Rq=TEA@mail.gmail.com> (sfid-20110728_231255_326308_A8926A0F)
Subject: Re: [PATCH 1/9] ath9k: Dump base eeprom header for AR9003
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2011 at 10:29 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> Debugfs file location:
> <debugfs_mnt>/ieee80211/phy#/ath9k/base_eeprom
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/debug.c |  147 ++++++++++++++++++++++++++++++++
>  1 files changed, 147 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index d1eb896..df71c72 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -1163,6 +1163,151 @@ static const struct file_operations fops_regdump = {
>        .llseek = default_llseek,/* read accesses f_pos */
>  };
>
> +static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
> +                                    size_t count, loff_t *ppos)
> +{
> +       struct ath_softc *sc = file->private_data;
> +       struct ath_hw *ah = sc->sc_ah;
> +       struct ar9300_base_eep_hdr *pBase = NULL;
> +       unsigned int len = 0, size = 1500;
> +       ssize_t retval = 0;
> +       char *buf;
> +
> +       if (!AR_SREV_9300_20_OR_LATER(ah))
> +               return 0;

This is really really cool stuff, but instead of doing this can we
instead implement this as a callback design which would enable other
hw revisions to be supported? If we do not then we need to make the
code branch out on each type of card.

  Luis
