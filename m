Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34623 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbcCWJ5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 05:57:49 -0400
Received: by mail-yw0-f182.google.com with SMTP id h129so12106170ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2016 02:57:48 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Mar 2016 02:57:48 -0700
Message-ID: <CALQ-SOAZ+T-kPK0_6s9v80QP+U5sBYtPzUDF2qnXgXuQ593-sg@mail.gmail.com> (sfid-20160323_105752_742150_6AE0CABE)
Subject: WMM vs QoS
From: Steven Pease <spease@suitabletech.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I've been tracking down some obscure wireless issues and noticed that
there doesn't seem to be a clean mapping between RFC4594 DSCP classes
and WMM queues.

Specifically, it appears that the highest priority defined for VOIP
traffic (EF), and which seems to be commonly used for voice, maps as
AC_VI (next-highest) rather than AC_VO (highest). Whereas I would've
naively expected AF41 to map as AC_VI and EF to map as AC_VO.

I might be misunderstanding something. However, if this is truly the
case, I'm wondering if there would be any adverse effects to modifying
mac80211 to cause EF packets to get translated into the AC_VO queue?
It seems like this way I might be able to have my cake and eat it too
rather than choosing between correct QoS on only one of L2 or L3.

Thanks.

-- 
- Steven
