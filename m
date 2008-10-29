Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:21193 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbYJ2IGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 04:06:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: sparse warnings
Date: Wed, 29 Oct 2008 09:06:03 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	Dan Williams <dcbw@redhat.com>, Daniel Drake <dsd@gentoo.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <1225209437.3598.16.camel@johannes.berg>
In-Reply-To: <1225209437.3598.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810290906.03696.hs4233@mail.mn-solutions.de> (sfid-20081029_090625_634879_FC2973CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> drivers/net/wireless/libertas/cmd.c:609:16: warning: cast to
> restricted __le16
> drivers/net/wireless/libertas/cmd.c:611:16: 
> warning: cast to restricted __le16

Yeah, this seems like a bug. In the cmd struct, it's defined as 
s8, so there is no need to use leXX_to_cpu() on it:

struct cmd_ds_802_11_rf_tx_power {
        struct cmd_header hdr;

        __le16 action;
        __le16 curlevel;
        s8 maxlevel;
        s8 minlevel;
};
