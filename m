Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:8004 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbYAJRML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 12:12:11 -0500
Received: by rv-out-0910.google.com with SMTP id k20so643282rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 09:12:10 -0800 (PST)
Message-ID: <c85cb4470801100912y2bb0521ej2414dd6a34421689@mail.gmail.com> (sfid-20080110_171215_979043_3DAC742A)
Date: Thu, 10 Jan 2008 19:12:10 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: linville@tuxdriver.com
Subject: Re: [RFC PATCH 0/10] mac80211/iwlwifi: A-MPDU Tx support
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1199984547375-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1199984547375-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

please ignore current series, i am sending the whole series over, this
series were sent by mistake
thanks
Ron


On 1/10/08, Ron Rindjunsky <ron.rindjunsky@intel.com> wrote:
> Hi folks
>
> This series is published as RFC, as I would like to address the design
> for A-MPDU TX, reflected in the API and in implementation, since the
> initiator side (Tx) is a bit more complicated then the recipient side (Rx).
>
> Recipient (Rx) flow:
> ====================
> regular Rx -> addBA request arrives -> addBA response send -> Rx switches to
> A-MPDU from starting sequence number published in addBA request -> A-MPDU Rx
> -> delBA arrives.
>
> What we would expect from Initiator (Tx) flow:
> ================================================
> regular Tx -> addBA request send -> addBA response arrives -> Tx switches to
> A-MPDU from starting sequence number published in addBA request -> A-MPDU Tx
> -> delBA send
>
> What are the pitfalls in Tx flow:
> =================================
> 1 - Session "handshake" idle time - As addBA request/response is being done
> during regular data flow the initiator can not just stop Tx and wait for
> recipient answer because it will cause a serious drop in performance,
> especially considering the fact that recipient can decline the request,
> so during this period Tx should continue, much the same like recipient
> does not stops Rx after addBA request arrives...
>
> 2 - Starting sequence number (ssn) - Because we don't want to stop Tx flow,
> starting sequence number for first possible A-MPDU frame should be forecasted,
> either based on mac80211 book keeping, but more likely on low-level driver
> estimation upon current HW queues status that are likely buffered with frames
> for Tx in regular mode, and in that case this forecast should be supplied to
> mac80211 by low level driver so a correct addBA request with the ssn will be
> issued to recipient.
>
> 3 - Finish Tx of regular MPDUs - If recipient does accept the addBA, and
> A-MPDU session should start, low level driver should first check that all
> queued frames for regular Tx on same TID prior to published ssn were delivered
> to recipient, and only then allow A-MPDU Tx. When stopping A-MPDU the opposite
> should happen, finish sending all A-MPDU, and only then send delBA and
> do regular Tx.
>
> 4 - Queue policy - regular Tx is based on QoS AC granularity, while A-MPDU Tx
> is based on TID/Receiving Address granularity, so already upon A-MPDU
> _intention_ (before addBA request is issued), already a classification change
> should occur, and return to QoS granularity only if aggregation stopped or
> declined.
>
> 5 - Queues drain (HW queues and Qdiscs) - so, derived from the above,
> either when starting or stopping A-MPDU session, HW queues and Qdiscs should
> first be examined and drained, so no packet loss due to wrong Tx mode,
> delay in Tx, or leftovers that were buffered in the queues will occur.
>
> So, considering these constraints, low-level driver needs to handle next issues:
> 1 - Starting sequence number (deliver to mac80211).
>    Done through the ampdu_action ops interface.
> 2 - Make sure HW queue are clear to Tx (TID criteria) and ready to
>    A-MPDU when starting aggregation (and report to mac80211 MLME),
>    and clear and ready to regular Tx when stopping aggregation
>    (and report to mac80211 MLME), This readiness will be reported
>    to mac80211 through the supplied call backs.
>
> While mac80211 will have to control:
> 1 - Session level (MLME), you can review these changes inside the patches.
> 2 - AC/TIDxRA queue policy (Qdisc). I have a functioning solution here,
>    but will be glad to hear comments and suggestions, as I not sure about
>    this implementation.
>
> Thanks everyone
> Ron
>
>
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
