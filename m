Return-Path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:33583 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389Ab2EQFvC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 01:51:02 -0400
From: Amit SHAKYA <amit.shakya@stericsson.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless (linux-wireless@vger.kernel.org)"
	<linux-wireless@vger.kernel.org>,
        "Johannes Berg (johannes@sipsolutions.net)"
	<johannes@sipsolutions.net>
Date: Thu, 17 May 2012 07:50:39 +0200
Subject: Recall: [PATCH] mac80211: Handle race condition in replay handling
Message-ID: <ECD438FDEF6BD742895E554C24725A4022946BBC7E@EXDCVYMBSTM005.EQ1STM.local>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amit SHAKYA would like to recall the message, "[PATCH] mac80211: Handle race condition in replay handling".--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
>From linux-wireless-owner@vger.kernel.org Thu May 17 09:12:02 2012
Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
	jmaline2.user.openhosting.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
	T_DKIM_INVALID,T_RP_MATCHES_RCVD autolearn=ham version=3.3.1
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by jmaline2.user.openhosting.com (8.13.8/8.13.8) with ESMTP id q4H6C1fx015354
	for <j@w1.fi>; Thu, 17 May 2012 02:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2EQGPI (ORCPT <rfc822;j@w1.fi>);
	Thu, 17 May 2012 02:15:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60687 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2EQGPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 02:15:07 -0400
DKIM-Signature: 	v=1; a=rsa-sha256; c=simple/simple;
  d=qca.qualcomm.com; i=kvalo@qca.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1337235307; x=1368771307;
  h=message-id:date:from:mime-version:to:cc:subject:
   references:in-reply-to:content-transfer-encoding;
  bh=S65kz6nR7mFBoCLkvJ40C2Z71r6DfKgQ+wPw061Q4xc=;
  b=qC34JftD0hu6dYeE3KW/cALLQOF9VDfcGf0OxvgnLeugRQ4U6zKeagjU
   Cyx2BTw2mLFsDMQ4HdSWRdha8co82sOWkcr2VEq3ny/zwfpiiO2ZSDBPR
   BaOwBAuFFjDIT2LX/8bZb6SZ2xsDBf7pZihZubsyrlnJ92lrwkZfm6DNl
   M=;
X-IronPort-AV: E=McAfee;i="5400,1158,6713"; a="191786987"
Received: from ironmsg03-r.qualcomm.com ([172.30.46.17])
  by wolverine01.qualcomm.com with ESMTP; 16 May 2012 23:15:07 -0700
X-IronPort-AV: E=Sophos;i="4.75,605,1330934400"; 
   d="scan'208";a="252825768"
Received: from nasanexhc05.na.qualcomm.com ([172.30.48.2])
  by Ironmsg03-R.qualcomm.com with ESMTP/TLS/RC4-SHA; 16 May 2012 23:15:07 -0700
Received: from [10.64.3.213] (172.30.48.1) by qcmail1.qualcomm.com
 (172.30.48.2) with Microsoft SMTP Server (TLS) id 14.2.283.3; Wed, 16 May
 2012 23:15:06 -0700
Message-ID: <4FB49765.2080105@qca.qualcomm.com>
Date: 	Thu, 17 May 2012 09:15:01 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: issue wmi disconnect after notifying cfg80211
References: <1337200873-3698-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1337200873-3698-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.48.1]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: 	linux-wireless@vger.kernel.org
Content-Length: 724
Lines: 18

On 05/16/2012 11:41 PM, Thomas Pedersen wrote:
> ath6kl would issue a wmi disconnect command in response to a remote
> disconnect and return early without notifying cfg80211, only sending a
> cfg80211_disconnected (with reason code always 3) in response to the
> second disconnect firmware event.
> 
> Pass the right reason code to cfg80211 on the first disconnect instead.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied with the extra description about the actual bug this is
fixing.

Kalle
