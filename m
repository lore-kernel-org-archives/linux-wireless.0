Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C8FC10F0F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 15:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5F03218C3
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 15:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbfDEPN4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 11:13:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34878 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbfDEPN4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 11:13:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hCQXN-0005x0-PI; Fri, 05 Apr 2019 17:13:49 +0200
Message-ID: <9371ebeec2af95a8884feab23dbb0b932d7cf9ce.camel@sipsolutions.net>
Subject: Re: [PATCH 0/6] stricter netlink validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, dsa@cumulusnetworks.com
Date:   Fri, 05 Apr 2019 17:13:48 +0200
In-Reply-To: <d423d283c91a48f75a509ee74255327cfe92fe97.camel@sipsolutions.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
         <20190404.102850.631122626573856353.davem@davemloft.net>
         <d423d283c91a48f75a509ee74255327cfe92fe97.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-05 at 13:47 +0200, Johannes Berg wrote:
> 
> I've also pushed some very much WIP code to the netlink-policy-export
> branch there that exposes the policies to userspace, there at least for
> generic netlink now.

Seems to more or less work now, userspace gets things like (for
nl80211):

(ID 0x18 is the nl80211 genl family)

	ID: 0x18  policy[0]:attr[1]: type=U32
[...]
	ID: 0x18  policy[0]:attr[87]: type=U32
	ID: 0x18  policy[0]:attr[88]: type=U64
	ID: 0x18  policy[0]:attr[89]: type=U8
	ID: 0x18  policy[0]:attr[90]: type=NESTED
	ID: 0x18  policy[0]:attr[91]: type=BINARY
[...]
	ID: 0x18  policy[0]:attr[270]: type=NESTED policy:1
[...]
	ID: 0x18  policy[0]:attr[273]: type=NESTED policy:2
[...]
	ID: 0x18  policy[1]:attr[1]: type=FLAG
	ID: 0x18  policy[1]:attr[2]: type=BINARY
	ID: 0x18  policy[1]:attr[3]: type=BINARY
[...]
	ID: 0x18  policy[2]:attr[1]: type=REJECT
	ID: 0x18  policy[2]:attr[2]: type=REJECT
	ID: 0x18  policy[2]:attr[3]: type=REJECT
	ID: 0x18  policy[2]:attr[4]: type=REJECT
	ID: 0x18  policy[2]:attr[5]: type=NESTED_ARRAY policy:3
[...]
	ID: 0x18  policy[3]:attr[3]: type=NESTED policy:4

etc.

See net/wireless/nl80211.c nl80211_policy[] for the original data, it's
unchanged over current net-next.


Policy 0 is - by convention - the top-level policy, but once I fix the
recursion issue in validate_nla() it's possible that a nested attribute
refers back to the top-level policy.

There are some bugs, like it generating an almost-empty message for when
the type is NLA_UNSPEC rather than eliding it entirely, and I haven't
implemented a bunch of things yet:

                /* TODO advertise range (min/max) */
                /* TODO advertise min/max len */
                /* TODO show reject string if any */

Also, I haven't hooked it up to anything that's not generic netlink, but
the API should be general enough for anyone:

int netlink_policy_dump_start(const struct nla_policy *policy,
                              unsigned int maxtype,
                              unsigned long *state);
bool netlink_policy_dump_loop(unsigned long *state);
int netlink_policy_dump_write(struct sk_buff *skb, unsigned long state);

(*state/state is &cb->args[n]/cb->args[n] for the netlink dump, it will
generate one message per type. That may be overkill, but it lets us
include the potentially long reject string etc. without worrying about
any message size limitations.)

It feels like it's working, and so I'd like to propose formal patches
soon.

Pablo, what do you think? It seems to me that this type of thing would
address most if not all what you did with the object/bus description
stuff, while not writing any new code, the info is taken straight from
the policy.

johannes

