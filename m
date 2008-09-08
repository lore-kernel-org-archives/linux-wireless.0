Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:18337 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYIHWY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 18:24:59 -0400
Received: by yx-out-2324.google.com with SMTP id 8so947734yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 15:24:57 -0700 (PDT)
Message-ID: <1ba2fa240809081524ia1860e3o3327a64c933a09a3@mail.gmail.com> (sfid-20080909_002506_319375_C770ED41)
Date: Tue, 9 Sep 2008 01:24:56 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1220897594.31304.83.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
	 <1220885742.31304.67.camel@johannes.berg>
	 <1220886337.31304.71.camel@johannes.berg>
	 <1220887018.31304.74.camel@johannes.berg>
	 <1ba2fa240809080953mfe2ab86l5417679e4cb29df1@mail.gmail.com>
	 <1220897594.31304.83.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 9:13 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-08 at 19:53 +0300, Tomas Winkler wrote:
>
>> The bug is that scan can be triggered in STA and IBSS internally. If
>> you request scan from the application (iwlist) while
>> internally scan is running application won't fetch scan results
>> because the -EBUSY is returned on scan request.
>
> But -EBUSY won't be returned if that same interface is already scanning,
> then 0 will be returned, so I don't understand?

Me either, but empirically the fix from Esti cured the problem. The
problem is seen only in IBSS. Will dig into this tomorrow.
Thanks
Tomas
