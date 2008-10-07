Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:40697 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYJGRpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:45:33 -0400
Received: by yw-out-2324.google.com with SMTP id 9so558861ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 10:45:32 -0700 (PDT)
Message-ID: <445f43ac0810071045j38cbdc4dxcc19bc41e5046a08@mail.gmail.com> (sfid-20081007_194536_936090_2CF63CE3)
Date: Tue, 7 Oct 2008 10:45:32 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/8] mac80211: remove writable debugs mesh parameters
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <20081007100439.450608000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081007100428.868688000@sipsolutions.net>
	 <20081007100439.450608000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Tue, Oct 7, 2008 at 3:04 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> These parameters shouldn't be configurable via debugfs, if they
> need to be configurable nl80211 support has to be added, if not
> then they don't need to be writable here either.

Ack (on behalf of Luisca as well, who is on sabbatical somewhere in Asia...)

Javier


> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Javier Cardona <javier@cozybit.com>
> Cc: Luis Carlos Cobo <luisca@cozybit.com>
> ---
>  net/mac80211/debugfs_netdev.c |  112 +++++++++---------------------------------
>  1 file changed, 24 insertions(+), 88 deletions(-)
>
> --- everything.orig/net/mac80211/debugfs_netdev.c       2008-10-07 11:26:52.000000000 +0200
> +++ everything/net/mac80211/debugfs_netdev.c    2008-10-07 11:27:00.000000000 +0200
> @@ -41,29 +41,6 @@ static ssize_t ieee80211_if_read(
>        return ret;
>  }
>
> -#ifdef CONFIG_MAC80211_MESH
> -static ssize_t ieee80211_if_write(
> -       struct ieee80211_sub_if_data *sdata,
> -       char const __user *userbuf,
> -       size_t count, loff_t *ppos,
> -       int (*format)(struct ieee80211_sub_if_data *, char *))
> -{
> -       char buf[10];
> -       int buf_size;
> -
> -       memset(buf, 0x00, sizeof(buf));
> -       buf_size = min(count, (sizeof(buf)-1));
> -       if (copy_from_user(buf, userbuf, buf_size))
> -               return count;
> -       read_lock(&dev_base_lock);
> -       if (sdata->dev->reg_state == NETREG_REGISTERED)
> -               (*format)(sdata, buf);
> -       read_unlock(&dev_base_lock);
> -
> -       return count;
> -}
> -#endif
> -
>  #define IEEE80211_IF_FMT(name, field, format_string)                   \
>  static ssize_t ieee80211_if_fmt_##name(                                        \
>        const struct ieee80211_sub_if_data *sdata, char *buf,           \
> @@ -71,19 +48,6 @@ static ssize_t ieee80211_if_fmt_##name(
>  {                                                                      \
>        return scnprintf(buf, buflen, format_string, sdata->field);     \
>  }
> -#define IEEE80211_IF_WFMT(name, field, type)                           \
> -static int ieee80211_if_wfmt_##name(                                   \
> -       struct ieee80211_sub_if_data *sdata, char *buf)                 \
> -{                                                                      \
> -       unsigned long tmp;                                              \
> -       char *endp;                                                     \
> -                                                                       \
> -       tmp = simple_strtoul(buf, &endp, 0);                            \
> -       if ((endp == buf) || ((type)tmp != tmp))                        \
> -               return -EINVAL;                                         \
> -       sdata->field = tmp;                                             \
> -       return 0;                                                       \
> -}
>  #define IEEE80211_IF_FMT_DEC(name, field)                              \
>                IEEE80211_IF_FMT(name, field, "%d\n")
>  #define IEEE80211_IF_FMT_HEX(name, field)                              \
> @@ -126,34 +90,6 @@ static const struct file_operations name
>                IEEE80211_IF_FMT_##format(name, field)                  \
>                __IEEE80211_IF_FILE(name)
>
> -#define __IEEE80211_IF_WFILE(name)                                     \
> -static ssize_t ieee80211_if_read_##name(struct file *file,             \
> -                                       char __user *userbuf,           \
> -                                       size_t count, loff_t *ppos)     \
> -{                                                                      \
> -       return ieee80211_if_read(file->private_data,                    \
> -                                userbuf, count, ppos,                  \
> -                                ieee80211_if_fmt_##name);              \
> -}                                                                      \
> -static ssize_t ieee80211_if_write_##name(struct file *file,            \
> -                                       const char __user *userbuf,     \
> -                                       size_t count, loff_t *ppos)     \
> -{                                                                      \
> -       return ieee80211_if_write(file->private_data,                   \
> -                                userbuf, count, ppos,                  \
> -                                ieee80211_if_wfmt_##name);             \
> -}                                                                      \
> -static const struct file_operations name##_ops = {                     \
> -       .read = ieee80211_if_read_##name,                               \
> -       .write = ieee80211_if_write_##name,                             \
> -       .open = mac80211_open_file_generic,                             \
> -}
> -
> -#define IEEE80211_IF_WFILE(name, field, format, type)                  \
> -               IEEE80211_IF_FMT_##format(name, field)                  \
> -               IEEE80211_IF_WFMT(name, field, type)                    \
> -               __IEEE80211_IF_WFILE(name)
> -
>  /* common attributes */
>  IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
>  IEEE80211_IF_FILE(force_unicast_rateidx, force_unicast_rateidx, DEC);
> @@ -212,30 +148,30 @@ IEEE80211_IF_FILE(dropped_frames_no_rout
>  IEEE80211_IF_FILE(estab_plinks, u.mesh.mshstats.estab_plinks, ATOMIC);
>
>  /* Mesh parameters */
> -IEEE80211_IF_WFILE(dot11MeshMaxRetries,
> -               u.mesh.mshcfg.dot11MeshMaxRetries, DEC, u8);
> -IEEE80211_IF_WFILE(dot11MeshRetryTimeout,
> -               u.mesh.mshcfg.dot11MeshRetryTimeout, DEC, u16);
> -IEEE80211_IF_WFILE(dot11MeshConfirmTimeout,
> -               u.mesh.mshcfg.dot11MeshConfirmTimeout, DEC, u16);
> -IEEE80211_IF_WFILE(dot11MeshHoldingTimeout,
> -               u.mesh.mshcfg.dot11MeshHoldingTimeout, DEC, u16);
> -IEEE80211_IF_WFILE(dot11MeshTTL, u.mesh.mshcfg.dot11MeshTTL, DEC, u8);
> -IEEE80211_IF_WFILE(auto_open_plinks, u.mesh.mshcfg.auto_open_plinks, DEC, u8);
> -IEEE80211_IF_WFILE(dot11MeshMaxPeerLinks,
> -               u.mesh.mshcfg.dot11MeshMaxPeerLinks, DEC, u16);
> -IEEE80211_IF_WFILE(dot11MeshHWMPactivePathTimeout,
> -               u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout, DEC, u32);
> -IEEE80211_IF_WFILE(dot11MeshHWMPpreqMinInterval,
> -               u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval, DEC, u16);
> -IEEE80211_IF_WFILE(dot11MeshHWMPnetDiameterTraversalTime,
> -               u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime, DEC, u16);
> -IEEE80211_IF_WFILE(dot11MeshHWMPmaxPREQretries,
> -               u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries, DEC, u8);
> -IEEE80211_IF_WFILE(path_refresh_time,
> -               u.mesh.mshcfg.path_refresh_time, DEC, u32);
> -IEEE80211_IF_WFILE(min_discovery_timeout,
> -               u.mesh.mshcfg.min_discovery_timeout, DEC, u16);
> +IEEE80211_IF_FILE(dot11MeshMaxRetries,
> +               u.mesh.mshcfg.dot11MeshMaxRetries, DEC);
> +IEEE80211_IF_FILE(dot11MeshRetryTimeout,
> +               u.mesh.mshcfg.dot11MeshRetryTimeout, DEC);
> +IEEE80211_IF_FILE(dot11MeshConfirmTimeout,
> +               u.mesh.mshcfg.dot11MeshConfirmTimeout, DEC);
> +IEEE80211_IF_FILE(dot11MeshHoldingTimeout,
> +               u.mesh.mshcfg.dot11MeshHoldingTimeout, DEC);
> +IEEE80211_IF_FILE(dot11MeshTTL, u.mesh.mshcfg.dot11MeshTTL, DEC);
> +IEEE80211_IF_FILE(auto_open_plinks, u.mesh.mshcfg.auto_open_plinks, DEC);
> +IEEE80211_IF_FILE(dot11MeshMaxPeerLinks,
> +               u.mesh.mshcfg.dot11MeshMaxPeerLinks, DEC);
> +IEEE80211_IF_FILE(dot11MeshHWMPactivePathTimeout,
> +               u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout, DEC);
> +IEEE80211_IF_FILE(dot11MeshHWMPpreqMinInterval,
> +               u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval, DEC);
> +IEEE80211_IF_FILE(dot11MeshHWMPnetDiameterTraversalTime,
> +               u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime, DEC);
> +IEEE80211_IF_FILE(dot11MeshHWMPmaxPREQretries,
> +               u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries, DEC);
> +IEEE80211_IF_FILE(path_refresh_time,
> +               u.mesh.mshcfg.path_refresh_time, DEC);
> +IEEE80211_IF_FILE(min_discovery_timeout,
> +               u.mesh.mshcfg.min_discovery_timeout, DEC);
>  #endif
>
>
>
> --
>
>



-- 
Javier Cardona
cozybit Inc.
