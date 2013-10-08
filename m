Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:41331 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754699Ab3JHUyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 16:54:52 -0400
Message-ID: <1381265688.23020.11.camel@joe-AO722> (sfid-20131008_225455_821923_02DA08A8)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680
 hardware
From: Joe Perches <joe@perches.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org
Date: Tue, 08 Oct 2013 13:54:48 -0700
In-Reply-To: <1381263958-14846-1-git-send-email-k.eugene.e@gmail.com>
References: <CAB=NE6Xs=ebxpQapB4xXu7edWfMEkgZu8hTyO98zfam56og2Hg@mail.gmail.com>
	 <1381263958-14846-1-git-send-email-k.eugene.e@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-08 at 21:25 +0100, Eugene Krasnikov wrote:
> This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
> far WCN3660/WCN3680 is available only on MSM platform.

some trivia:

> diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
[]
> +static ssize_t read_file_bool_bmps(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct wcn36xx *wcn = file->private_data;
> +	struct wcn36xx_vif *vif_priv = NULL;
> +	struct ieee80211_vif *vif = NULL;
> +	char buf[3];
> +
> +	list_for_each_entry(vif_priv, &wcn->vif_list, list) {
> +			vif = container_of((void *)vif_priv,
> +				   struct ieee80211_vif,
> +				   drv_priv);
> +			if (NL80211_IFTYPE_STATION == vif->type) {
> +				if (vif_priv->pw_state == WCN36XX_BMPS)
> +					buf[0] = '1';
> +				else
> +					buf[0] = '0';
> +				break;
> +			}

please indent this properly.

	list_for_each...(...) {
		statement...;
		statement...;
	}

[]

> +static ssize_t write_file_bool_bmps(struct file *file,
> +				    const char __user *user_buf,
> +				    size_t count, loff_t *ppos)
> +{
> +	struct wcn36xx *wcn = file->private_data;
> +	struct wcn36xx_vif *vif_priv = NULL;
> +	struct ieee80211_vif *vif = NULL;
> +
> +	char buf[32];
> +	int buf_size;
> +
> +	buf_size = min(count, (sizeof(buf)-1));
> +	if (copy_from_user(buf, user_buf, buf_size))
> +		return -EFAULT;
> +
> +	switch (buf[0]) {
> +	case 'y':
> +	case 'Y':
> +	case '1':
> +		list_for_each_entry(vif_priv, &wcn->vif_list, list) {
> +			vif = container_of((void *)vif_priv,
> +				   struct ieee80211_vif,
> +				   drv_priv);
> +			if (NL80211_IFTYPE_STATION == vif->type) {

trivia:

Please use
			if (test == CONSTANT)

Yes, I know the compiler complains if you
mistakenly leave out one of the = this way.

> +#define ADD_FILE(name, mode, fop, priv_data)		\
> +	do {							\
> +		struct dentry *d;				\
> +		d = debugfs_create_file(__stringify(name),	\
> +					mode, dfs->rootdir,	\
> +					priv_data, fop);	\
> +		dfs->file_##name.dentry = d;			\
> +		if (IS_ERR(d)) {				\
> +			wcn36xx_warn("Create the debugfs entry failed");\

missing "\n" newline

> +			dfs->file_##name.dentry = NULL;		\
[]

> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
[]
> +static int wcn36xx_dxe_init_descs(struct wcn36xx_dxe_ch *wcn_ch)
> +{
> +	struct wcn36xx_dxe_desc *cur_dxe = NULL;
> +	struct wcn36xx_dxe_desc *prev_dxe = NULL;
> +	struct wcn36xx_dxe_ctl *cur_ctl = NULL;
> +	size_t size;
> +	int i;
> +
> +	size = wcn_ch->desc_num * sizeof(struct wcn36xx_dxe_desc);
> +	wcn_ch->cpu_addr = dma_alloc_coherent(NULL, size, &wcn_ch->dma_addr,
> +					      GFP_KERNEL);

	dma_zalloc_coherent

[]
> +	memset(wcn_ch->cpu_addr, 0, size);

No longer required.

> +		if (0 == i) {

too many styles mixing i == 0 and 0 == i

[]

> +int wcn36xx_dxe_allocate_mem_pools(struct wcn36xx *wcn)
> +{
> +	size_t s;

mixing s and size above, please use one style/name.

> +	void *cpu_addr;
> +
> +	/* Allocate BD headers for MGMT frames */
> +
> +	/* Where this come from ask QC */
> +	wcn->mgmt_mem_pool.chunk_size =	WCN36XX_BD_CHUNK_SIZE +
> +		16 - (WCN36XX_BD_CHUNK_SIZE % 8);
> +
> +	s = wcn->mgmt_mem_pool.chunk_size * WCN36XX_DXE_CH_DESC_NUMB_TX_H;
> +	cpu_addr = dma_alloc_coherent(NULL, s, &wcn->mgmt_mem_pool.phy_addr,
> +				      GFP_KERNEL);

	same use of dma_zalloc_coherent(...)

> +	if (!cpu_addr)
> +		goto out_err;
> +
> +	wcn->mgmt_mem_pool.virt_addr = cpu_addr;
> +	memset(cpu_addr, 0, s);

Now unnecessary memset.

too long, stopped reading.




