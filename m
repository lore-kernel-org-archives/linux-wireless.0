Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4818 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbXIMTLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 15:11:10 -0400
Date: Thu, 13 Sep 2007 14:39:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: ian <ischram@telenet.be>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: letting drivers choose their preferred rate scale
Message-ID: <20070913183918.GA10239@tuxdriver.com>
References: <46CF95F9.6090802@telenet.be> <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be> <1188211749.6756.11.camel@johannes.berg> <20070831180933.GB3352@tuxdriver.com> <46DB537E.8030801@telenet.be> <1188808692.14564.24.camel@johannes.berg> <46DC1500.7090808@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46DC1500.7090808@telenet.be>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 03, 2007 at 04:06:56PM +0200, ian wrote:
> Johannes Berg wrote:
> > On Mon, 2007-09-03 at 02:21 +0200, ian wrote:
> > 
> >> we could additionally remove the module_alias from rc80211_simple
> > 
> > indeed, please roll into this patch
> > 
> I don't know enough from debugfs yet, to do that part, but I'll read up.
> 
> ---
> Make rc80211_simple the default rate scaling algorithm

> @@ -78,11 +78,12 @@ static struct rate_control_ops *
>  ieee80211_rate_control_ops_get(const char *name)
>  {
>  	struct rate_control_ops *ops;
> +	const char *try_name = name ? name : "simple";
> 
> -	ops = ieee80211_try_rate_control_ops_get(name);
> +	ops = ieee80211_try_rate_control_ops_get(try_name);
>  	if (!ops) {
> -		request_module("rc80211_%s", name ? name : "default");
> -		ops = ieee80211_try_rate_control_ops_get(name);
> +		request_module("rc80211_%s", try_name);
> +		ops = ieee80211_try_rate_control_ops_get(try_name);
>  	}
>  	return ops;
>  }
> --- a/net/mac80211/rc80211_simple.c	2007-09-03 15:53:42.000000000 +0200
> +++ b/net/mac80211/rc80211_simple.c	2007-09-03 15:54:40.000000000 +0200
> @@ -29,7 +29,6 @@
>  #define RATE_CONTROL_INTERVAL (HZ / 20)
>  #define RATE_CONTROL_MIN_TX 10
> 
> -MODULE_ALIAS("rc80211_default");
> 
>  static void rate_control_rate_inc(struct ieee80211_local *local,
>  				  struct sta_info *sta)
 
Does this actually change anything?  With the MODULE_ALIAS line
in rc80211_simple.c, doesn't the request_module("rc80211_default")
just load rc80211_simple?

Confused...

John
-- 
John W. Linville
linville@tuxdriver.com
