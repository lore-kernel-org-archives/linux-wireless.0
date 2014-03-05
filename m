Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaCEJQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 04:16:51 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jouni Malinen <j@w1.fi>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 2/2] mac80211: ignore probe response from adjacent
 channels
Date: Wed, 5 Mar 2014 09:16:44 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D786F6@HASMSX103.ger.corp.intel.com> (sfid-20140305_101657_542494_A1AD3E15)
References: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
 <1393944614-4465-2-git-send-email-emmanuel.grumbach@intel.com>
 <20140305090854.GA3544@w1.fi>
In-Reply-To: <20140305090854.GA3544@w1.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Tue, Mar 04, 2014 at 04:50:14PM +0200, Emmanuel Grumbach wrote:
> > This logic is already implemented in ieee80211_rx_mgmt_beacon.
> > The purpose is to ignore probe responses that are received on adjacent
> > channels. This can happen in 2.4GHz since channels overlap.
> 
> Why would this be done? I can understand not updating signal information,
> but dropping Probe Response frames completely sounds quite undesirable.
> These can be used to help optimize partial scans and any additional
> information that can be used without having to change channels sounds
> helpful to me.
> 

So I guess you want me to revert the code we currently have in ieee80211_rx_mgmt_beacon ;)
Don't know really... If you are associated to an AP and hear its beacons / probe responses on another channel you really have a big problem in your radio?
