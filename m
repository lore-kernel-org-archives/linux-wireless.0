Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2LDNYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 08:24:03 -0500
Message-ID: <1354627464.9608.0.camel@jlt4.sipsolutions.net> (sfid-20121204_142407_503413_8E8E7003)
Subject: Re: [RFC] mac80211: add debugfs file for mic failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 04 Dec 2012 14:24:24 +0100
In-Reply-To: <50BDF869.5030702@posedge.com>
References: <50BDF869.5030702@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-04 at 18:49 +0530, Saravana wrote:
> The mic failure count will provide the number of mic failure that 
> have happened without a countermeasure being started. Once the 
> countermeasure is started, the counter will be reset to 0.
> This count will be helpful when the consecutive 
> mic failure occur at intervals greater than 60 seconds regularly(frequently).
> 
> Signed-off-by: Saravana <saravanad@posedge.com>
> ---
>  net/mac80211/debugfs_key.c |   20 ++++++++++++++++++++
>  net/mac80211/key.h         |    3 +++
>  net/mac80211/wpa.c         |    2 ++
>  3 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
> index 2d42354..1cc262e 100644
> --- a/net/mac80211/debugfs_key.c
> +++ b/net/mac80211/debugfs_key.c
> @@ -199,6 +199,25 @@ static ssize_t key_icverrors_read(struct file *file, char __user *userbuf,
>  }
>  KEY_OPS(icverrors);
>  
> +static ssize_t key_mic_failures_read(struct file *file, char __user *userbuf,
> +				  size_t count, loff_t *ppos)

please fix indentation

> +{
> +	struct ieee80211_key *key = file->private_data;
> +	char buf[20];
> +	int len;
> +
> +	switch (key->conf.cipher) {
> +	case WLAN_CIPHER_SUITE_TKIP:
> +		len = scnprintf(buf, sizeof(buf), "%u\n",
> +				key->u.tkip.mic_failures);
> +		break;
> +	default:
> +		return 0;
> +	}

I think this should just be

if (key->conf.cipher != TKIP)
	return -EINVAL;

len = scnprintf(...)

> +	return simple_read_from_buffer(userbuf, count, ppos, buf, len);

Other than that looks fine.

johannes

