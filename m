Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.237]:30458 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbXFLOVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 10:21:01 -0400
Received: by wx-out-0506.google.com with SMTP id t15so1804354wxc
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2007 07:21:00 -0700 (PDT)
Message-ID: <1ba2fa240706120721y78f7f4e1u2ff795b0bdedcca2@mail.gmail.com>
Date: Tue, 12 Jun 2007 17:21:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1181636314.4758.30.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070611085950.GA5540@mail.intel.com>
	 <1181584907.29767.30.camel@johannes.berg>
	 <1ba2fa240706120037g767a330fsa1e838f378ce2b58@mail.gmail.com>
	 <1181636314.4758.30.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/12/07, Zhu Yi <yi.zhu@intel.com> wrote:
> On Tue, 2007-06-12 at 10:37 +0300, Tomas Winkler wrote:
> > This is correct that power save must be disabled explicitly in this
> > implementation.  Usually you want to establish DLS for increasing
> > throughput so you won't go to power save mode anyway.
>
> Right.
>
> > One other thing is encryption, the path for peer key handshake must be
> > opened in mac80211 in addition to this patch.
>
> Authentication or encryption? I don't think either mac80211 or
> wpa_supplicant supports IBSS WPA/WPA2 currently, right. For WEP, it
> should work since both DLS peers use the same key as set in the AP.
>

Authentication is against AP in any case. In addition you have peer
key hand shake for exchanging  encryption keys.  It is similar to
EAPOL hand shake, need to keep port closed till the keys are
available. This should be supported in supplicant.
WEP is global to bss so there is no problem.

> Thanks,
> -yi
>
