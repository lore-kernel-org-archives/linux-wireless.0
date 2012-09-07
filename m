Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab2IGNBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 09:01:23 -0400
Date: Fri, 7 Sep 2012 08:59:58 -0400
From: Andy Gospodarek <gospo@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	backports@vger.kernel.org
Subject: Re: [PATCH] compat: drop const to fix compiler warnings
Message-ID: <20120907125958.GD3638@quad.redhat.com> (sfid-20120907_150137_725659_9F998445)
References: <1347004574-80506-1-git-send-email-nbd@openwrt.org>
 <CAB=NE6V6vAdsVQyjKyaMYnPRQdJLc+Gt=nqiS5cN9mWU3vz7aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6V6vAdsVQyjKyaMYnPRQdJLc+Gt=nqiS5cN9mWU3vz7aQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 07, 2012 at 02:04:37AM -0700, Luis R. Rodriguez wrote:
> On Fri, Sep 7, 2012 at 12:56 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> > When calling pci_find_capability and pci_read_config_word, struct pci_dev
> > needs to be passed without const.
> 
> Thanks! I guess because at certain kernel version pci_dev was const ?
> 

Similar issues exist with ethtool_ops, but it's not a huge deal, imo.
