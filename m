Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:16025 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXEYQPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2007 12:15:21 -0400
Date: Fri, 25 May 2007 09:20:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
Message-Id: <20070525092008.287b5ecd.randy.dunlap@oracle.com>
In-Reply-To: <20070525115244.GA23364@mail.intel.com>
References: <20070525115244.GA23364@mail.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 25 May 2007 19:52:44 +0800 Zhu Yi wrote:

>  net/mac80211/debugfs_netdev.c |  332 +++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/ieee80211_i.h    |   33 ++++
>  2 files changed, 365 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> index 9e39646..e0f77f9 100644
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c

> +#define DEBUGFS_QOS_DEL(name)						\
> +	debugfs_remove(sdata->debugfs.sta.qos.name);			\
> +	sdata->debugfs.sta.qos.name = NULL;

Enclose multi-line macros inside braces, or even better, inside

	do {
		/* multi-lines */
	} while (0);


> +#define DEBUGFS_TSINFO_DEL(name)					\
> +	debugfs_remove(sdata->debugfs.sta.tsinfo.name);			\
> +	sdata->debugfs.sta.tsinfo.name = NULL;

ditto.

> +#define DEBUGFS_TSPEC_DEL(name)						\
> +	debugfs_remove(sdata->debugfs.sta.tspec.name);			\
> +	sdata->debugfs.sta.tspec.name = NULL;

ditto.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
