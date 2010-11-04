Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39759 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0KDAVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 20:21:04 -0400
Received: by wyf28 with SMTP id 28so1275402wyf.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 17:21:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101102083100.GN1733@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
 <1288659351-22313-7-git-send-email-brian@cozybit.com> <20101102083100.GN1733@mail.wantstofly.org>
From: Brian Cavagnolo <brian@cozybit.com>
Date: Wed, 3 Nov 2010 17:20:43 -0700
Message-ID: <AANLkTi=EoFN_AyaWtwFrLOinE27sUbTxmPnxPbmforQw@mail.gmail.com>
Subject: Re: [PATCH 7/7] mac80211: unset SDATA_STATE_OFFCHANNEL when
 cancelling a scan
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 2, 2010 at 1:31 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Mon, Nov 01, 2010 at 05:55:51PM -0700, Brian Cavagnolo wrote:
>
>> For client STA interfaces, ieee80211_do_stop unsets the relevant
>> interface's SDATA_STATE_RUNNING state bit prior to cancelling an
>> interrupted scan.  When ieee80211_offchannel_return is invoked as
>> part of cancelling the scan, it doesn't bother unsetting the
>> SDATA_STATE_OFFCHANNEL bit because it sees that the interface is
>> down.  Normally this doesn't matter because when the client STA
>> interface is brought back up, it will probably issue a scan.  But
>> in some cases (e.g., the user changes the interface type while it
>> is down), the SDATA_STATE_OFFCHANNEL bit will remain set.  This
>> prevents the interface queues from being started.  So we
>> unconditionally unset this bit when we cancel a scan.
>
> How does this patch fit into the series?
>

Sorry.  That should have gone to Johannes.  I'll resubmit.
