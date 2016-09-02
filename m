Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932464AbcIBP4p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:56:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82FrIkk072096
        for <linux-wireless@vger.kernel.org>; Fri, 2 Sep 2016 11:56:44 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25787vnd0j-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2016 11:56:44 -0400
Received: from localhost
        by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Sat, 3 Sep 2016 01:56:40 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
        by d23dlp02.au.ibm.com (Postfix) with ESMTP id E4C4E2BB0057
        for <linux-wireless@vger.kernel.org>; Sat,  3 Sep 2016 01:56:37 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u82FubQi4325730
        for <linux-wireless@vger.kernel.org>; Sat, 3 Sep 2016 01:56:37 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u82Fubi5023742
        for <linux-wireless@vger.kernel.org>; Sat, 3 Sep 2016 01:56:37 +1000
Subject: Re: linux-4.8-rcX:  ath9k traceback
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 02 Sep 2016 11:56:34 -0400
In-Reply-To: <87eg5338b5.fsf@purkki.adurom.net>
References: <1472682267.2607.8.camel@linux.vnet.ibm.com>
         <87eg5338b5.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-Id: <1472831794.2773.1.camel@linux.vnet.ibm.com> (sfid-20160902_175654_756843_ECD38ADE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-01 at 19:15 +0300, Kalle Valo wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> 
> > There weren't any problems on linux-4.7 kernels.  I'm getting the
> > following traceback on linux-4.8-rc1/-rc4 kernels.  Let me know if you
> > need any additional information.
> >
> > [   64.006529] WARNING: CPU: 3 PID: 94 at drivers/net/wireless/ath/ath9k/beacon.c:642 ath9k_beacon_config+0x12c/0x140 [ath9k]
> 
> This should fix it:
> 
> ath9k: fix client mode beacon configuration
> 
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=05860bed491b114a9f2d7a4f6e09fb02c0b69056


Yep, that resolved the problem.  Thanks!

Mimi
