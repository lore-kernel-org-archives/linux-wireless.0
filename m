Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34939 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbcAaHad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 02:30:33 -0500
Received: by mail-lf0-f67.google.com with SMTP id j99so3899173lfi.2
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2016 23:30:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160130235613.GB1507@localhost>
References: <1454062138-18012-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1454062138-18012-4-git-send-email-henning.rogge@fkie.fraunhofer.de> <20160130235613.GB1507@localhost>
From: Henning Rogge <hrogge@gmail.com>
Date: Sun, 31 Jan 2016 08:30:01 +0100
Message-ID: <CAGnRvurcTY4VaZ-q8KTfW07LsnAEgkhDsBZeHiaVa88u-kf6yA@mail.gmail.com> (sfid-20160131_083036_694226_0D4E8336)
Subject: Re: [PATCH v2 3/3] mac80211: Unify mesh and mpp path removal function
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 31, 2016 at 12:56 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Jan 29, 2016 at 11:08:58AM +0100, Henning Rogge wrote:
>> @@ -951,37 +974,14 @@ enddel:
>>   */
>>  static int mpp_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
>>  {
>> -     struct mesh_table *tbl;
>> -     struct mesh_path *mpath;
>> -     struct mpath_node *node;
>> -     struct hlist_head *bucket;
>> -     int hash_idx;
>> -     int err = 0;
>> -
>> -     /* flush relevant mpp entries first */
>> -     mpp_flush_by_proxy(sdata, addr);
>> -
>
> Is it intentional that mpp_path_del no longer calls mpp_flush_by_proxy()
> while mesh_path_del does?

You just found a bug in the original patch... the "mpp_flush_by_proxy"
is the function that erase all MPP entries going through a certain
MPath entry... so it is wrong in the mpp_path_del() function.

I will respin the series tomorrow.

Henning
