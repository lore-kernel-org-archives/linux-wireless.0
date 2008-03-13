Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:30451 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYCMX5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 19:57:40 -0400
Received: by wa-out-1112.google.com with SMTP id v27so4236693wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 13 Mar 2008 16:57:39 -0700 (PDT)
Message-ID: <1ba2fa240803131657o3858f12ey1b55d0f23a216f7f@mail.gmail.com> (sfid-20080313_235745_516030_946A06F2)
Date: Fri, 14 Mar 2008 01:57:39 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: Tkip fix sparse endianity complain in tkip code
Cc: linville@tuxdriver.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1205442130.15910.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205431553-20567-1-git-send-email-tomas.winkler@intel.com>
	 <1205442130.15910.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 13, 2008 at 11:02 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  On Thu, 2008-03-13 at 20:05 +0200, Tomas Winkler wrote:
>  > This patch fix wrong cast in tkip code
>  >
>  > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>  > ---
>  >  net/mac80211/tkip.c |    2 +-
>  >  1 files changed, 1 insertions(+), 1 deletions(-)
>  >
>  > diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
>  > index f61f1dd..0ce2a84 100644
>  > --- a/net/mac80211/tkip.c
>  > +++ b/net/mac80211/tkip.c
>  > @@ -118,7 +118,7 @@ static u8 *set_ext_iv(u8 *pos, u16 iv16)
>  >
>  >  static u8 *set_tkip_iv(u8 *pos, u32 iv32)
>  >  {
>  > -     *((u32 *)pos) = cpu_to_le32(iv32);
>  > +     *((__le32 *)pos) = cpu_to_le32(iv32);
>
>  The patch introducing this code will be reverted because this is also
>  rather bad code since it's not known that "pos" is aligned to a
>  four-byte boundary.

Agree, actually I was puzzled it was even merged in after all these
discussions. Anyhow it sparsed into my eye so I put a patch on it.

>
>  johannes
>
