Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45692 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1KUTkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 14:40:03 -0500
Received: by qadc14 with SMTP id c14so516791qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 11:40:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321868640.3999.17.camel@jlt3.sipsolutions.net>
References: <1321868640.3999.17.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Mon, 21 Nov 2011 11:39:39 -0800
Message-ID: <CAB=NE6WNe6nAO_jysrPUX8-5_siPKwgank0RExYMFTBU8BBrng@mail.gmail.com> (sfid-20111121_204007_905012_972EBF2F)
Subject: Re: [PATCH] cfg80211: fix regulatory NULL dereference
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 1:44 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> By the time userspace returns with a response to
> the regulatory domain request, the wiphy causing
> the request might have gone away. If this is so,
> reject the update but mark the request as having
> been processed anyway.
>
> Cc: Luis R. Rodriguez <lrodriguez@qca.qualcomm.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/reg.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> --- a/net/wireless/reg.c        2011-11-10 09:27:32.000000000 +0100
> +++ b/net/wireless/reg.c        2011-11-21 10:41:57.000000000 +0100
> @@ -2037,6 +2037,10 @@ static int __set_regdom(const struct iee
>        }
>
>        request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
> +       if (!request_wiphy) {
> +               reg_set_request_processed();
> +               return -ENODEV;
> +       }
>
>        if (!last_request->intersect) {
>                int r;

last_request is still populated with the driver request info though,
so you'd have to reset_regdomains() too to clear last_request as if
we're starting all over again. If you don't get to it, I'm working on
two fixes that cover this.

  Luis
