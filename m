Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44396 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2DYEYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 00:24:40 -0400
Received: by wibhj6 with SMTP id hj6so4584660wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 21:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
References: <CAOvK7nAOHqKC8rpFDqGnW7NLCX-G2+syRGih_rv7N5O5rfOUdA@mail.gmail.com>
Date: Wed, 25 Apr 2012 07:24:39 +0300
Message-ID: <CANUX_P1t8XJOka-QGzZSYFHb6MLc7rm4madn059Yg4b6hJB49A@mail.gmail.com> (sfid-20120425_062443_974440_79680905)
Subject: Re: iwlwifi bug
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: dchyan@princeton.edu
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2012 at 04:58, Daniel Chyan <dchyan@princeton.edu> wrote:
> Hi Linux Wireless,
>
> I believe there is a bug within iwlwifi aggregation. I am on the
> latest build (2012-04-23). Here is the dmesg output:
>
> [  272.093668] ------------[ cut here ]------------
> [  272.093711] WARNING: at
> /home/foo/bar/compat-wireless-2012-04-23/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:493
> iwl_trans_pcie_tx_agg_disable+0x101/0x110 [iwlwifi]()
> [  272.093719] Hardware name: 4177CTO
> [  272.093722] queue 11 not used

How reproducible is that ?
We are trying to stop AMPDU on a queue on which they were never
started... which is ... odd.
