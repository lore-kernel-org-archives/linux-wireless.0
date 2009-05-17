Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:43336 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbZEQVAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 17:00:15 -0400
Received: by pzk13 with SMTP id 13so1734693pzk.33
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 14:00:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090517181911.GA3455@newton.monom.org>
References: <20090517181911.GA3455@newton.monom.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 17 May 2009 13:59:55 -0700
Message-ID: <43e72e890905171359q639fe5dco4327187b4fe7909f@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211_hwsim: Group radios
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 17, 2009 at 11:19 AM, Daniel Wagner <wagi@monom.org> wrote:
> Currently all radios receive all traffic on the simulated air
> if they are tuned to the same channel. This patch introduces
> the concept of grouping, which allows to assign a radio to
> certain group. Only radios in the same group can 'see' each other.
>
> Each bit in /debug/ieee80211/phy*/hwsim/group
> represents one group. By default all radios belong to the same group "1",
> e.g. bit 1 is set. Additionally a radio can belong to several groups.
>
> Signed-off-by: Daniel Wagner <wagi@monom.org>
> ---
> v2: Explain the patch a bit better in the commit message.
>
>  drivers/net/wireless/mac80211_hwsim.c |   30 +++++++++++++++++++++++++++++-
>  1 files changed, 29 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 61a4ad7..58fd29e 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -291,6 +291,9 @@ struct mac80211_hwsim_data {
>        bool ps_poll_pending;
>        struct dentry *debugfs;
>        struct dentry *debugfs_ps;

How about some

/*
  * comments heres explaining what a group is too
  * otherwise one will have to guess by looking at the code
  */
> +
> +       u64 group;
> +       struct dentry *debugfs_group;
>  };
>
>
> @@ -412,7 +415,8 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
>
>                if (!data2->started || !data2->radio_enabled ||
>                    !hwsim_ps_rx_ok(data2, skb) ||
> -                   data->channel->center_freq != data2->channel->center_freq)
> +                   data->channel->center_freq != data2->channel->center_freq ||
> +                   !(data->group & data2->group))
>                        continue;
>
>                nskb = skb_copy(skb, GFP_ATOMIC);
> @@ -720,6 +724,7 @@ static void mac80211_hwsim_free(void)
>        spin_unlock_bh(&hwsim_radio_lock);
>
>        list_for_each_entry(data, &tmplist, list) {
> +               debugfs_remove(data->debugfs_group);
>                debugfs_remove(data->debugfs_ps);
>                debugfs_remove(data->debugfs);
>                ieee80211_unregister_hw(data->hw);
> @@ -872,6 +877,24 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
>                        "%llu\n");
>
>
> +static int hwsim_fops_group_read(void *dat, u64 *val)
> +{
> +       struct mac80211_hwsim_data *data = dat;
> +       *val = data->group;
> +       return 0;
> +}
> +
> +static int hwsim_fops_group_write(void *dat, u64 val)
> +{
> +       struct mac80211_hwsim_data *data = dat;
> +       data->group = val;
> +       return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
> +                       hwsim_fops_group_read, hwsim_fops_group_write,
> +                       "%llx\n");
> +
>  static int __init init_mac80211_hwsim(void)
>  {
>        int i, err = 0;
> @@ -976,6 +999,8 @@ static int __init init_mac80211_hwsim(void)
>
>                        hw->wiphy->bands[band] = sband;
>                }
> +               /* By default all radios are belonging to the first group */
> +               data->group = 1;
>
>                /* Work to be done prior to ieee80211_register_hw() */
>                switch (regtest) {
> @@ -1100,6 +1125,9 @@ static int __init init_mac80211_hwsim(void)
>                data->debugfs_ps = debugfs_create_file("ps", 0666,
>                                                       data->debugfs, data,
>                                                       &hwsim_fops_ps);
> +               data->debugfs_group = debugfs_create_file("group", 0666,
> +                                                       data->debugfs, data,
> +                                                       &hwsim_fops_group);
>
>                setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
>                            (unsigned long) hw);
> --
> 1.6.2.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
