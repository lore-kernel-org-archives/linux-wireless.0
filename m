Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50114 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbbKLW3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 17:29:10 -0500
Message-ID: <56451294.9060205@codeaurora.org> (sfid-20151112_232915_190166_F4A163B8)
Date: Thu, 12 Nov 2015 14:28:36 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] cfg80211: add VHT support for Mesh
References: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com> <1447358605.2131.3.camel@sipsolutions.net> <564505A6.9030001@codeaurora.org> <1447364413.2131.5.camel@sipsolutions.net>
In-Reply-To: <1447364413.2131.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 11/12/2015 01:40 PM, Johannes Berg wrote:
> On Thu, 2015-11-12 at 13:33 -0800, Peter Oh wrote:
>> At this moment Mesh Point is not able to be brought up by userspace
>> such
>> as wap_supplicant at VHT data rates because there is no
>> events/NL80211
>> defined that userspace can check out if drivers can support Mesh
>> Point
>> (802.11s) at VHT data rates or not, hence only HT data rates can be
>> used
>> for
>> Mesh Point by userspace now.
>> This patch is introducing NL80211 event to cover the issue.
> No... this patch doesn't introduce an nl80211 event. It introduces a
> feature flag, but I'm arguing it's useless.
>
> Look - what's the difference that userspace would do based on this
> flag? Clearly, setting the flag in the driver has no effect on kernel
> code whatsoever, so your "is not able to be brought up" makes no sense.
Yes directly but no indirectly.
Setting the flag in the driver will have effect to the driver eventually 
by userspace since the flag will be sent up to userspace and userspace 
will select data rates according to the flag.
setting NL80211_VHT_MESH flag in driver -> wpa_supplicant requests 
driver capabilities via NL80211 -> driver sends up its capabilities 
including VHT_MESH -> wpa_supplicant parses and check if VHT_MESH is set 
-> wpa_supplicant configures the driver with VHT data rates if the flag 
set or configure HT data rates.
>
> Perhaps it'll become clearer once you post the wpa_supplicant code,
This is ath10k driver diff I sent out for upstream review.

@@ -7266,6 +7266,7 @@ int ath10k_mac_register(struct ath10k *ar)
  	}
  
  	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_VHT_MESH);

and a part of wpa_supplicant changes.
@@ -359,6 +359,9 @@ static void wiphy_info_ext_feature_flags(struct 
wiphy_info_d
         if (ext_feature_isset(nla_data(tb), nla_len(tb),
                               NL80211_EXT_FEATURE_VHT_IBSS))
                 capa->flags |= WPA_DRIVER_FLAGS_VHT_IBSS;
+       if (ext_feature_isset(nla_data(tb), nla_len(tb),
+               NL80211_EXT_FEATURE_VHT_MESH))
+               capa->flags |= WPA_DRIVER_FLAGS_VHT_MESH;

@@ -1885,12 +1885,13 @@ void ibss_mesh_setup_freq(struct wpa_supplicant 
*wpa_s,
-       /* Not sure if mesh is ready for VHT */
+       /* For IBSS/Mesh check VHT flag */
+       if (ssid->mode == WPAS_MODE_MESH &&
+           !(wpa_s->drv_flags & WPA_DRIVER_FLAGS_VHT_MESH))
                 return;
>   but
> you should still coherently explain in the commit message why this is
> necessary.
The both of wpa_supplicant and ath10k patches have explanation in their 
commit message already.
>   So far, I don't see it, since no kernel code ever depends on
> this flag.
A ath10k driver patch in upstream review is using the flag.
Exactly the same communication mechanism and purpose are used with 
NL80211_EXT_FEATURE_VHT_IBSS which is already a part of NL80211 feature 
flag.
The new feature flag, NL80211_EXT_FEATURE_VHT_MESH, follows the same 
purpose and usage.
>
> johannes
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
