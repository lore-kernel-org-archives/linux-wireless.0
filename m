Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:41858 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYIFXYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 19:24:36 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1037475fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 16:24:34 -0700 (PDT)
Message-ID: <1ba2fa240809061624n2ec9537n6f280c5ef6641181@mail.gmail.com> (sfid-20080907_012440_004625_7680B732)
Date: Sun, 7 Sep 2008 02:24:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220740939.21016.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220739930.21016.6.camel@johannes.berg>
	 <1ba2fa240809061532s4f8e08c1xe59f99768ce440c0@mail.gmail.com>
	 <1220740939.21016.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 1:42 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2008-09-07 at 01:32 +0300, Tomas Winkler wrote:
>> On Sun, Sep 7, 2008 at 1:25 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> >
>> >>
>> >> +static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>> >> +                                  struct ieee80211_if_sta *ifsta, int deauth,
>> >> +                                  int self_disconnected, u16 reason)
>> >
>> > I think you should use bool for those two (deauth, self)
>>
>> I'm thinking rather using some enum values just for readability
>> foo(DEAUTH, ORIGIN_SELF) vs foo(tree,true)
>> foo(DISASSOC, ORIGIN_PEER)  vs foo(false, false)
>
> That works too, sure, though seems a little overkill, the function is
> called what, three times? Anyway, whatever you prefer, I just don't like
> bare "int" as a bool.

Do u think it is sane using IEEE80211_STYPE_DISASSOC and
IEEE80211_STYPE_DEAUTH for this?
Thanks
Tomas
