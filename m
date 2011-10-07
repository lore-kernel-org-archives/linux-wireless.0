Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57016 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1JGT5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 15:57:25 -0400
Received: by qyk30 with SMTP id 30so977556qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 12:57:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318017260.3974.9.camel@jlt3.sipsolutions.net>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1317772067-6998-4-git-send-email-mcgrof@qca.qualcomm.com> <1318017260.3974.9.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Fri, 7 Oct 2011 12:57:05 -0700
Message-ID: <CAB=NE6WOvik7hJygC8cTpe+o1W==fsqw2ZgVA=_pbo6fpFhUzw@mail.gmail.com> (sfid-20111007_215729_182970_23C63E6F)
Subject: Re: [PATCH 3/8] cfg80211: process regulatory DFS region for countries
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2011 at 12:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-10-04 at 16:47 -0700, Luis R. Rodriguez wrote:
>
>>  /**
>> + * enum nl80211_dfs_regions - regulatory DFS regions
>> + *
>> + * @NL80211_DFS_UNSET: Country has no DFS master region specified
>> + * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
>> + * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
>> + * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
>> + */
>> +enum nl80211_cflags {
>> +     NL80211_DFS_UNSET       = 0,
>
> That seems odd -- nl80211 convention would be to just leave out the
> attribute.

I wonder what seems more odd, having that present or looking at this:

+bool reg_supported_dfs_region(u8 dfs_region)
+{
+       switch (dfs_region) {
+       case 0:
+       case NL80211_DFS_FCC:
+       case NL80211_DFS_ETSI:
+       case NL80211_DFS_JP:
+               return true;
+       default:
+               REG_DBG_PRINT("Ignoring uknown DFS master region: %d\n",
+                             dfs_region);
+               return false;
+       }
+}

Vs:

+bool reg_supported_dfs_region(u8 dfs_region)
+{
+       switch (dfs_region) {
+       case NL80211_DFS_UNSET:
+       case NL80211_DFS_FCC:
+       case NL80211_DFS_ETSI:
+       case NL80211_DFS_JP:
+               return true;
+       default:
+               REG_DBG_PRINT("Ignoring uknown DFS master region: %d\n",
+                             dfs_region);
+               return false;
+       }
+}

You pick, you're the maintainer.

  Luis
