Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43945 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab2FOAcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 20:32:19 -0400
Received: by gglu4 with SMTP id u4so1914255ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 17:32:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339700228.9786.11.camel@jlt3.sipsolutions.net>
References: <1339691033-13316-1-git-send-email-yeohchunyeow@gmail.com>
	<1339700228.9786.11.camel@jlt3.sipsolutions.net>
Date: Fri, 15 Jun 2012 08:32:18 +0800
Message-ID: <CAEFj985xi0LNsLqHn1cgAw0oMVsfWrh_ioPuzUva8ZLbUTn=ZQ@mail.gmail.com> (sfid-20120615_023224_791905_B208BE4C)
Subject: Re: [PATCH] mac80211: fix the assignment of mesh element TTL
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes.

On Fri, Jun 15, 2012 at 2:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-15 at 00:23 +0800, Chun-Yeow Yeoh wrote:
>> This patch fixes the wrong assignment of mesh element TTL.
>
> Since I haven't pushed to John yet, should I rebase and merge this with
> one of the previous patches?
>
> johannes
>
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> ---
>>  net/mac80211/cfg.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>> index 85ac364..43eb8d9 100644
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -1529,7 +1529,7 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
>>       if (_chg_mesh_attr(NL80211_MESHCONF_TTL, mask))
>>               conf->dot11MeshTTL = nconf->dot11MeshTTL;
>>       if (_chg_mesh_attr(NL80211_MESHCONF_ELEMENT_TTL, mask))
>> -             conf->dot11MeshTTL = nconf->element_ttl;
>> +             conf->element_ttl = nconf->element_ttl;
>>       if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
>>               conf->auto_open_plinks = nconf->auto_open_plinks;
>>       if (_chg_mesh_attr(NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR, mask))
>
>
