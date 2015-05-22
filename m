Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35492 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754AbbEVJwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 05:52:06 -0400
Received: by wicmx19 with SMTP id mx19so41754052wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 02:52:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKz9MK95nqzZk0=yP=UX3JvEy_JFsY5yZ3FEcOOGstBVQ@mail.gmail.com>
References: <CABPxzYKz9MK95nqzZk0=yP=UX3JvEy_JFsY5yZ3FEcOOGstBVQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 22 May 2015 15:21:44 +0530
Message-ID: <CABPxzY+jxZq=irAiCzSw_xVDcp3jbWQOmj3qsTzZs9r8OCMjDA@mail.gmail.com> (sfid-20150522_115212_153434_2F78935B)
Subject: Re: Not able to set u-apsd for P2P client
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 8, 2015 at 8:16 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
>
> Hi,
>
> We are having trouble making the uapsd working in p2p client case. Is
> this broken? or is there a way to configure the uapsd for p2p client
> case?
>
>
> case a) p2p client with p2p_no_group_iface=1
>
> When trying to change the mode from MANAGED to P2P_CLIENT the sdata is
> being cleared so the previous change of uapsd_queue=0xF is being
> cleared and default value is taken.
>
> case b) with p2p_no_group_iface=0
>
> As the interface is dynamically created, we cannot use the mac80211
> debugfs to set the uapsd_queues.
> I have tried "wpa_cli p2p_set client_apsd 1,1,1,1" but it is not taking effect.
>
May be this is more of a mac80211 issue, currently while preparing
association request frame mac80211 uses imgd->uapsd_queues, so
need fetch that information from usespace up on interface addition viz.
a nl command? curently only NL command which has this info is ADD_STA
which is used in TDLS case.

Any ideas are appreciated.
