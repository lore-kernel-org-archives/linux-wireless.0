Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41888 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab0JHR4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 13:56:24 -0400
Received: by qyk1 with SMTP id 1so246101qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 10:56:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286492072.20974.49.camel@jlt3.sipsolutions.net>
References: <201009210057.13297.chunkeey@googlemail.com> <20100924180013.GD8077@tuxdriver.com>
 <201009250002.21219.chunkeey@googlemail.com> <AANLkTinCkWGs_KMz+QBUw2J5HUVU2hK1+8kVDr_PNZwP@mail.gmail.com>
 <1286492072.20974.49.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 8 Oct 2010 10:56:02 -0700
Message-ID: <AANLkTin6nwrhcGdnGxg_gMGSrD_GBc-R51qiendF4iAc@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steve deRosier <steve@cozybit.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Thu, Oct 7, 2010 at 3:54 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> Javier and I reviewed the patch and it definitely fixes a potential
>> problem and is correct.  Furthermore, applied to wireless-testing
>> head, it passes all of our cases in our test bed.
>>
>> I think it's good to go.
>
> Err, are you positive? I think the code there is correct, apart from the
> fact that it does no validation of
> mgmt->u.action.u.plink_action.action_code whatsoever which may allow all
> kinds of abuse :)
>
> The only action that's valid w/o having a station entry for the peer is
> PLINK_OPEN, which makes perfect sense.

We believe Christian's second patch fixes a null-pointer de-reference
that would be triggered by a PLINK_OPEN frame with
mismatching/incompatible mesh configuration.  Let's analyze that case:

void mesh_rx_plink_frame(...)
(...)
sta = sta_info_get(sdata, mgmt->sa);    <-- will return null
if (!sta && ftype != PLINK_OPEN) {       <-- false for PLINK_OPEN frames
(...)
if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
<-- true for PLINK_OPEN, non-compatible mesh config
             (...)
             spin_lock_bh(&sta->lock);         <-- boom!


The patch not only solves this problem, but also responds correctly to
non-compatible PLINK_OPEN frames by generating a PLINK_CLOSE with the
right reason code.

Cheers,

Javier
