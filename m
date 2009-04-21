Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZDUBOw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 21:14:52 -0400
Subject: Re: [PATCH] cfg80211: mark all WEXT handlers _GPL
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1240246179.4632.6.camel@johannes.local>
References: <1240246179.4632.6.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 09:08:56 +0800
Message-Id: <1240276136.354.107.camel@debian> (sfid-20090421_031456_289133_AE3CCDAF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-21 at 00:49 +0800, Johannes Berg wrote:
> The fact that these are exported is a technical detail
> of the conversion period -- we don't want anybody to
> start relying on these. Ultimately we want things to
> use cfg80211 only, and once everything that is in wext
> is converted to cfg80211 drivers will not need to touch
> wext _at all_.

Johannes, why don't you want them to be used by others, say some fullmac
drivers? These functions can be used as glue from wext to cfg80211 in
the conversion period. After cfg80211 is ultimately used, they can be
removed all together of course.

Thanks,
-yi
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/wireless/scan.c        |    4 ++--
>  net/wireless/wext-compat.c |   24 ++++++++++++------------
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 
> --- wireless-testing.orig/net/wireless/scan.c	2009-04-20 18:47:21.000000000 +0200
> +++ wireless-testing/net/wireless/scan.c	2009-04-20 18:47:45.000000000 +0200
> @@ -653,7 +653,7 @@ int cfg80211_wext_siwscan(struct net_dev
>  	cfg80211_put_dev(rdev);
>  	return err;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_siwscan);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
>  
>  static void ieee80211_scan_add_ies(struct iw_request_info *info,
>  				   struct cfg80211_bss *bss,
> @@ -962,5 +962,5 @@ int cfg80211_wext_giwscan(struct net_dev
>  	cfg80211_put_dev(rdev);
>  	return res;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_giwscan);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_giwscan);
>  #endif
> --- wireless-testing.orig/net/wireless/wext-compat.c	2009-04-20 18:47:21.000000000 +0200
> +++ wireless-testing/net/wireless/wext-compat.c	2009-04-20 18:47:33.000000000 +0200
> @@ -57,7 +57,7 @@ int cfg80211_wext_giwname(struct net_dev
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_giwname);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_giwname);
>  
>  int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
>  			  u32 *mode, char *extra)
> @@ -108,7 +108,7 @@ int cfg80211_wext_siwmode(struct net_dev
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_siwmode);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_siwmode);
>  
>  int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
>  			  u32 *mode, char *extra)
> @@ -143,7 +143,7 @@ int cfg80211_wext_giwmode(struct net_dev
>  	}
>  	return 0;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_giwmode);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_giwmode);
>  
> 
>  int cfg80211_wext_giwrange(struct net_device *dev,
> @@ -239,7 +239,7 @@ int cfg80211_wext_giwrange(struct net_de
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_giwrange);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_giwrange);
>  
>  int cfg80211_wext_siwmlme(struct net_device *dev,
>  			  struct iw_request_info *info,
> @@ -283,7 +283,7 @@ int cfg80211_wext_siwmlme(struct net_dev
>  		return -EOPNOTSUPP;
>  	}
>  }
> -EXPORT_SYMBOL(cfg80211_wext_siwmlme);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_siwmlme);
>  
> 
>  /**
> @@ -313,7 +313,7 @@ struct ieee80211_channel *cfg80211_wext_
>  	}
>  
>  }
> -EXPORT_SYMBOL(cfg80211_wext_freq);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_freq);
>  
>  int cfg80211_wext_siwrts(struct net_device *dev,
>  			 struct iw_request_info *info,
> @@ -338,7 +338,7 @@ int cfg80211_wext_siwrts(struct net_devi
>  
>  	return err;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_siwrts);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_siwrts);
>  
>  int cfg80211_wext_giwrts(struct net_device *dev,
>  			 struct iw_request_info *info,
> @@ -352,7 +352,7 @@ int cfg80211_wext_giwrts(struct net_devi
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_giwrts);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_giwrts);
>  
>  int cfg80211_wext_siwfrag(struct net_device *dev,
>  			  struct iw_request_info *info,
> @@ -379,7 +379,7 @@ int cfg80211_wext_siwfrag(struct net_dev
>  
>  	return err;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_siwfrag);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_siwfrag);
>  
>  int cfg80211_wext_giwfrag(struct net_device *dev,
>  			  struct iw_request_info *info,
> @@ -393,7 +393,7 @@ int cfg80211_wext_giwfrag(struct net_dev
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_giwfrag);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_giwfrag);
>  
>  int cfg80211_wext_siwretry(struct net_device *dev,
>  			   struct iw_request_info *info,
> @@ -434,7 +434,7 @@ int cfg80211_wext_siwretry(struct net_de
>  
>  	return err;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_siwretry);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_siwretry);
>  
>  int cfg80211_wext_giwretry(struct net_device *dev,
>  			   struct iw_request_info *info,
> @@ -464,4 +464,4 @@ int cfg80211_wext_giwretry(struct net_de
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(cfg80211_wext_giwretry);
> +EXPORT_SYMBOL_GPL(cfg80211_wext_giwretry);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

