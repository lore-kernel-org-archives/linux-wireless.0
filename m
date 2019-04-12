Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0722C282CE
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 09:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA73E20850
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 09:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfDLJnP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:43:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44866 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbfDLJnP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 05:43:15 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hEsiH-0001Ki-0e; Fri, 12 Apr 2019 11:43:13 +0200
Message-ID: <77171f971a4398ed81693060eebd9b3dee05aecd.camel@sipsolutions.net>
Subject: Re: [PATCH 2/6] netlink: make validation more configurable for
 future strictness
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Ahern <dsa@cumulusnetworks.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Fri, 12 Apr 2019 11:43:12 +0200
In-Reply-To: <86911e8d-2818-67f8-058b-ab2f4db33e55@cumulusnetworks.com> (sfid-20190410_185527_376809_3FA3CDDE)
References: <20190404065408.5864-1-johannes@sipsolutions.net>
         <20190404065408.5864-3-johannes@sipsolutions.net>
         <86911e8d-2818-67f8-058b-ab2f4db33e55@cumulusnetworks.com>
         (sfid-20190410_185527_376809_3FA3CDDE)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-10 at 09:55 -0700, David Ahern wrote:
> On 4/3/19 11:54 PM, Johannes Berg wrote:
> > @@ -280,6 +287,12 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
> >  		break;
> >  
> >  	case NLA_UNSPEC:
> > +		if (validate & NL_VALIDATE_UNSPEC) {
> > +			NL_SET_ERR_MSG_ATTR(extack, nla,
> > +					    "Attribute not understood");
> 
> I found that confusing when I did a trial run for a new route attribute.
> How about "Unsupported attribute"?

Sure, makes sense. I've changed it in my branch (mac80211-next tree,
netlink-validation branch).

johannes

