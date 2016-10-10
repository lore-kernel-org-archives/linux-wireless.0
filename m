Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53548 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752492AbcJJO5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 10:57:16 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Marty Faltesek <mfaltesek@google.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: cache calibration data when the core is
 stopped
Date: Mon, 10 Oct 2016 14:54:08 +0000
Message-ID: <8760p0jlv4.fsf@kamboji.qca.qualcomm.com> (sfid-20161010_165720_417861_512FCA1B)
References: <1475699037-136212-1-git-send-email-mfaltesek@google.com>
In-Reply-To: <1475699037-136212-1-git-send-email-mfaltesek@google.com> (Marty
        Faltesek's message of "Wed, 5 Oct 2016 16:23:57 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> Caching calibration data allows it to be accessed when the
> device is not active.
>
> ---

Signed-off-by missing. Can you send it as a reply to this message and
I'll add it to v3?

>  drivers/net/wireless/ath/ath10k/core.h  |  1 +
>  drivers/net/wireless/ath/ath10k/debug.c | 72 ++++++++++++++-------------=
------
>  2 files changed, 31 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireles=
s/ath/ath10k/core.h
> index 6e5aa2d..7274ebe 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -452,6 +452,7 @@ struct ath10k_debug {
>  	u32 nf_cal_period;
> =20
>  	struct ath10k_fw_crash_data *fw_crash_data;
> +	void *cal_data;

To properly document locking I'll move this under the "protected by
conf_mutex" comment.

> -static int ath10k_debug_cal_data_open(struct inode *inode, struct file *=
file)
> +static int ath10k_debug_cal_data_fetch(struct ath10k *ar)
>  {
> -	struct ath10k *ar =3D inode->i_private;
> -	void *buf;
>  	u32 hi_addr;
>  	__le32 addr;
>  	int ret;
> =20
> -	mutex_lock(&ar->conf_mutex);

I'll add lockdep_assert_held() here.

>  static ssize_t ath10k_debug_cal_data_read(struct file *file,
> -					  char __user *user_buf,
> -					  size_t count, loff_t *ppos)
> +                                          char __user *user_buf,
> +                                          size_t count, loff_t *ppos)
>  {
>  	struct ath10k *ar =3D file->private_data;
> -	void *buf =3D file->private_data;
> =20
>  	return simple_read_from_buffer(user_buf, count, ppos,
> -				       buf, ar->hw_params.cal_data_len);
> -}

I'll add locking to this function.

> @@ -2343,7 +2327,9 @@ int ath10k_debug_create(struct ath10k *ar)
>  	ar->debug.fw_crash_data =3D vzalloc(sizeof(*ar->debug.fw_crash_data));
>  	if (!ar->debug.fw_crash_data)
>  		return -ENOMEM;
> -
> +	ar->debug.cal_data =3D vzalloc(ar->hw_params.cal_data_len);
> +	if (!ar->debug.cal_data)
> +		return -ENOMEM;
>  	INIT_LIST_HEAD(&ar->debug.fw_stats.pdevs);
>  	INIT_LIST_HEAD(&ar->debug.fw_stats.vdevs);
>  	INIT_LIST_HEAD(&ar->debug.fw_stats.peers);
> @@ -2355,7 +2341,9 @@ int ath10k_debug_create(struct ath10k *ar)
>  void ath10k_debug_destroy(struct ath10k *ar)
>  {
>  	vfree(ar->debug.fw_crash_data);
> +	vfree(ar->debug.cal_data);
>  	ar->debug.fw_crash_data =3D NULL;
> +	ar->debug.cal_data =3D NULL;

Actually I gave you a bad advice, this won't work as
ar->hw_params.cal_data_len is not yet initialised, we initialise it only
after we have probed the capabilities during the first firmware boot. I
changed the allocation to a fixed length buffer for now, it's only few
kBs virtual memory anyway so it shouldn't matter to anyone.

I have now v3 ready and tested. I'll just need your Signed-off-by and I
can then submit it.

--=20
Kalle Valo=
