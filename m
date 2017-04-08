Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:33322 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbdDHSuN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 14:50:13 -0400
Received: by mail-pg0-f50.google.com with SMTP id x125so87378698pgb.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Apr 2017 11:50:13 -0700 (PDT)
Subject: Re: [PATCH 4/5] netlink: pass extended ACK struct to parsing
 functions
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20170408174900.12820-1-johannes@sipsolutions.net>
 <20170408174900.12820-5-johannes@sipsolutions.net>
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us,
        Johannes Berg <johannes.berg@intel.com>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <3077bf17-553d-f9e3-8873-c59fbb26e2aa@cumulusnetworks.com> (sfid-20170408_205017_562014_3A676F58)
Date: Sat, 8 Apr 2017 14:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <20170408174900.12820-5-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/8/17 1:48 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Pass the new extended ACK reporting struct to all of the
> generic netlink parsing functions. For now, pass NULL in
> almost all callers (except for some in the core.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

fails to compile as well:

In file included from /home/dsa/kernel-4.git/net/sched/cls_rsvp.c:27:0:
/home/dsa/kernel-4.git/net/sched/cls_rsvp.h: In function ‘rsvp_change’:
/home/dsa/kernel-4.git/net/sched/cls_rsvp.h:487:8: error: too few
arguments to function ‘nla_parse_nested’
  err = nla_parse_nested(tb, TCA_RSVP_MAX, opt, rsvp_policy);
        ^
In file included from /home/dsa/kernel-4.git/include/net/rtnetlink.h:5:0,
                 from /home/dsa/kernel-4.git/include/net/sch_generic.h:12,
                 from /home/dsa/kernel-4.git/include/linux/filter.h:20,
                 from /home/dsa/kernel-4.git/include/net/sock.h:64,
                 from /home/dsa/kernel-4.git/include/net/inet_sock.h:27,
                 from /home/dsa/kernel-4.git/include/net/ip.h:30,
                 from /home/dsa/kernel-4.git/net/sched/cls_rsvp.c:18:
/home/dsa/kernel-4.git/include/net/netlink.h:754:19: note: declared here
 static inline int nla_parse_nested(struct nlattr *tb[], int maxtype,
