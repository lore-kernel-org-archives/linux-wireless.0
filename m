Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40132 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab1DDUin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 16:38:43 -0400
Received: by wya21 with SMTP id 21so5019766wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 13:38:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301919673.3870.10.camel@jlt3.sipsolutions.net>
References: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
	<1301919673.3870.10.camel@jlt3.sipsolutions.net>
Date: Mon, 4 Apr 2011 13:38:41 -0700
Message-ID: <BANLkTim8wWf08fqRzG3F9KfMiq0WGzq0WQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] {mac|nl}80211: mesh security enhancements
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 4, 2011 at 5:21 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-04-01 at 13:35 -0700, Thomas Pedersen wrote:
>> v6:
>> - remove unneeded bits (Johannes)
>> - mesh capabilities returned for a wiphy & check if wiphy supports mesh
>>   authentication before joining a secure mesh (Johannes)
>>
>> Javier Cardona (9):
>>   nl80211: rename NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
>>   nl80211: Add userspace authentication  flag to mesh setup
>>   mac80211: ignore peers if security is enabled for this mesh
>>   nl80211: let userspace authenticate stations
>>   mac80211: Let user space receive and send mesh auth/deauth frames
>>   mac80211: ignore peer link requests from unauthenticated stations.
>>   mac80211: Perform PLINK_ACTION on new station
>>   nl80211: New notification to discover mesh peer candidates.
>>   mac80211: send notification on new peer candidate for our secure mesh
>>
>> Thomas Pedersen (1):
>>   nl80211: report mesh capabilities
>
> I don't believe this patchset works, since mac80211 doesn't set
> @WIPHY_FLAG_MESH_AUTH afaict.
>

in patch 10/10:
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0ae9b22..55cc521 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -761,6 +761,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
       /* mesh depends on Kconfig, but drivers should set it if they want */
       local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
 #endif
+       /* if the underlying driver supports mesh, mac80211 will (at least)
+        * provide routing of mesh authentication frames to userspace */
+       if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_MESH_POINT))
+               local->hw.wiphy->flags |= WIPHY_FLAG_MESH_AUTH;

       /* mac80211 supports control port protocol changing */
       local->hw.wiphy->flags |= WIPHY_FLAG_CONTROL_PORT_PROTOCOL;

> johannes
>
>
