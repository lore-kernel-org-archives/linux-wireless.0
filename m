Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45970 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2INPKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 11:10:49 -0400
Received: by oago6 with SMTP id o6so2930354oag.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Sep 2012 08:10:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <25df68a.fd56.139c4d65f66.Coremail.lishen565@126.com>
References: <1347603511-31165-1-git-send-email-yeohchunyeow@gmail.com>
	<61696420.fc66.139c4c167b7.Coremail.lishen565@126.com>
	<25df68a.fd56.139c4d65f66.Coremail.lishen565@126.com>
Date: Fri, 14 Sep 2012 23:10:49 +0800
Message-ID: <CAEFj985N-3EhL0Y71_28w42ZNWkuZBZ-r1uX0EZ2++jkU-aiqA@mail.gmail.com> (sfid-20120914_171053_558249_9F41C4AD)
Subject: Re: Re:[PATCH] mac80211: allow re-open the blocked peer link in mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great to hear that it works.

---
Chun-Yeow

On Fri, Sep 14, 2012 at 8:52 PM, 李申 <lishen565@126.com> wrote:
> I'm sorry that I made a mistake in the process of modifying the source code.Now it works well.Thank you for your help!
> At 2012-09-14 20:29:32,"李申" <lishen565@126.com> wrote:
>>I have modified the souce code as the patch shows.I'm sorry that it doesn't work and station plink state is still BLOCKED.
>>At 2012-09-14 14:18:31,"Chun-Yeow Yeoh" <yeohchunyeow@gmail.com> wrote:
>>>Peer link which is blocked using the "iw mesh0 station
>>>set <MAC addr> plink_action block" is previously not able
>>>to re-open using "iw mesh0 station set <MAC addr>
>>>plink_action open". This patch is intended to solve this.
>>>
>>>If the station plink state remains at OPN_SNT once open,
>>>try block and open again should solve this problem.
>>>
>>>Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>>>---
>>> net/mac80211/mesh_plink.c |    3 ++-
>>> 1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>>diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
>>>index 9d7ad36..3ab34d8 100644
>>>--- a/net/mac80211/mesh_plink.c
>>>+++ b/net/mac80211/mesh_plink.c
>>>@@ -537,7 +537,8 @@ int mesh_plink_open(struct sta_info *sta)
>>>      spin_lock_bh(&sta->lock);
>>>      get_random_bytes(&llid, 2);
>>>      sta->llid = llid;
>>>-     if (sta->plink_state != NL80211_PLINK_LISTEN) {
>>>+     if (sta->plink_state != NL80211_PLINK_LISTEN &&
>>>+         sta->plink_state != NL80211_PLINK_BLOCKED) {
>>>              spin_unlock_bh(&sta->lock);
>>>              return -EBUSY;
>>>      }
>>>--
>>>1.7.0.4
>>>
>>>_______________________________________________
>>>Devel mailing list
>>>Devel@lists.open80211s.org
>>>http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
>>
>>_______________________________________________
>>Devel mailing list
>>Devel@lists.open80211s.org
>>http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
