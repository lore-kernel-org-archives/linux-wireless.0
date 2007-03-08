Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXCHMnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 07:43:12 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1173207492.3503.13.camel@johannes.berg> 
References: <1173207492.3503.13.camel@johannes.berg> 
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: using keys service for wireless 
Date: Thu, 08 Mar 2007 12:43:00 +0000
Message-ID: <10771.1173357780@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:

> Oh, there's an issue with group keys vs. pairwise keys which means that a
> single connection can have multiple keys and for outgoing packets we choose
> one of them to do the encryption with, same for incoming packets.

Sounds messy:-)

> Looking at this, I notice that if we wanted to use the key service we'd
> still have to tell the stack/driver about the encryption type [1] we
> want to use as well as when to start using it.

Surely you have to tell it that anyway at some level.  And can you not embed
it in the key payload?

As an example, I've just been reimplementing my in-kernel RxRPC (AFS) service
to provide (a) a socket interface so userspace can use it, and (b) security.
The way I do things is that userspace adds a key to its session keyring with a
description of that name of the AFS cell (by calling the klog program).

The type of security required (kerberos4 is currently the only option) is
embedded within the key.  When a userspace AFS client program wants to use a
secured RxRPC socket, it nominates the name of the key it wants by a socket
option:

	char cell[] = "afs@CAMBRIDGE.REDHAT.COM";
	ret = setsockopt(client, SOL_RXRPC, RXRPC_SECURITY_KEY,
			 cell, strlen(cell));
	OSERROR(ret, "key");

and the kernel then calls request_key() on that description to get the key,
which it can then retain attached to the socket structure in the kernel.

The server side of things I've done by giving the server AF_RXRPC socket a
keyring with the server's secret list attached as keys:

	keyring = add_key("keyring", "AFSkeys", NULL, 0,
			  KEY_SPEC_PROCESS_KEYRING);
	OSERROR(keyring, "add_key/ring");

	const char secret[8] = { 0xa7, 0x83, 0x8a, 0xcb, 0xc7, 0x83, 0xec,
				 0x94 };

	key = add_key("rxrpc_s", "52:2", secret, 8, keyring);
	OSERROR(key, "add_key");

	ret = setsockopt(server, SOL_RXRPC, RXRPC_SECURITY_KEYRING,
			 "AFSkeys", 7);
	OSERROR(ret, "set keyring");

The keys in the keyring are named for the RxRPC service ID (52 - Volume
Location Service) being provided and the security type (2 - kerberos).  This
permits the server to add and remove keys without pestering the socket.

Using the keytype's match() function, it would be possible to have a key
named, say, "afs@cambridge.redhat.com:52:2" and match the bit I wanted
depending on the pattern given to match().  For RxRPC, however, the keys are
very different, so it doesn't actually make any sense to do that.


Now this analogy may or may not help you.  I'll leave that up to you.

David
