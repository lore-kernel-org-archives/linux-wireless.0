Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33439 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbcGGAfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 20:35:53 -0400
Subject: Re: [RFC 0/7] netlink: Add allocation flag to netlink_unicast()
To: ccaulfie@redhat.com, teigland@redhat.com
References: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-audit@redhat.com, cluster-devel@redhat.com,
	davem@davemloft.net, johannes@sipsolutions.net,
	pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	dledford@redhat.com, sean.hefty@intel.com,
	hal.rosenstock@gmail.com, paul@paul-moore.com, eparis@redhat.com,
	zbr@ioremap.net, pshelar@nicira.com, bsingharora@gmail.com
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <577DA3E1.6020103@gmail.com> (sfid-20160707_023607_150435_37FA1E4D)
Date: Thu, 7 Jul 2016 09:35:45 +0900
MIME-Version: 1.0
In-Reply-To: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the fs/dlm/netlink.c#dlm_timeout_warn(),
prepare_data allocates buffer with GFP_NOFS
and send_data() sends the buffer.

But send_data() uses GFP_KERNEL or GFP_ATOMIC inside it.
Should it be replaced by GFP_NOFS ?

Masashi Honma

