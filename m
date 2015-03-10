Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39201 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbbCJQso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:48:44 -0400
Message-ID: <1426006121.1926.6.camel@sipsolutions.net> (sfid-20150310_174847_487190_25280D68)
Subject: Re: [PATCH v2] mac80211: Get IV len from key conf and not cipher
 scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Max Stepanov <Max.Stepanov@intel.com>
Date: Tue, 10 Mar 2015 17:48:41 +0100
In-Reply-To: <5842EA9CC042B141995329508713AD672105A9FB@ILMAIL1.corp.local>
References: <5842EA9CC042B141995329508713AD672105A9B0@ILMAIL1.corp.local>
	 <1426003477.1926.5.camel@sipsolutions.net>
	 <5842EA9CC042B141995329508713AD672105A9FB@ILMAIL1.corp.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-10 at 16:46 +0000, Cedric Izoard wrote:
> > How can this be correct? You have a cipher scheme, so you want to
> > encrypt, but now you're not doing that? Perhaps you should drop the
> > frame instead?
> >
> On Tx, cipher scheme is "only" available trough sta pointer and is only 
> used in ieee80211_crypto_cs_encrypt to get security header len.
> Since sta pointer is NULL for bcast messages, the proposed patch get the 
> security header length using the key->conf.iv_len instead.
> 
> If the key is installed with a cs, then key->conf.iv_len is initialized 
> with cs->hdr_len.
> 
> If the key is installed without a cs, then  key->conf.iv_len is 0 (hence 
> the early exit in ieee80211_crypto_cs_encrypt)

So in reality, you're checking "is this a CS key"? Perhaps there's a
better way to do that?

johannes

