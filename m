Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:4050 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797AbXFHTes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 15:34:48 -0400
Message-ID: <466992FD.4050608@linux.intel.com>
Date: Fri, 08 Jun 2007 10:33:49 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: zergavis <zergavis@o2.pl>, linux-wireless@vger.kernel.org
Subject: Re: mac80211 "wme.c:398" error
References: <1279688715.20070608205031@o2.pl> <1181330294.6533.81.camel@johannes.berg>
In-Reply-To: <1181330294.6533.81.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-06-08 at 20:50 +0200, zergavis wrote:
> 
>> net/mac80211/wme.c: In function 'wme_qdiscop_destroy':
>> net/mac80211/wme.c:358: warning: implicit declaration of function 
>> 'tcf_destroy_chain'
>> net/mac80211/wme.c: In function 'wme_qdiscop_init':
>> net/mac80211/wme.c:398: warning: dereferencing 'void *' pointer
>> net/mac80211/wme.c:398: error: request for member 'wiphy' in something not 
>> a structure or union
>>
>> Could someone help me handle with this?
> 
> enable CONFIG_NET_SCHED for now.
> 
> johannes

CONFIG_NET_SCHED being set is the problem w/ older kernels.  We missed backporting tcf_destroy_chain and missed an ieee80211_ptr reference (and that code path is only included if CONFIG_NET_SCHED=y).

If you turn *off* CONFIG_NET_SCHED, it should build and run fine (which is what I'm doing on 2.6.18 and 2.6.20 systems currently)

I'm testing a fix for that now, which will be in mac80211-8.0.1.

James
