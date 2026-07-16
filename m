Received: from out02-fra1-mx.uberspace.de (out02-fra1-mx.uberspace.de [185.139.157.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388DF424D64;
	Thu, 16 Jul 2026 14:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.139.157.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210490; cv=none; b=G0o6vQ1YZwjEWH9Aqy0K5xs+QOieJBRuYqYDJs9clFOOknidznGnX+d11KvkmedYpvKUmY0+fSR+OPy3zTeFeR+I2c0vfP0ZLc0kqFUoOZLjUxYyatINbslK/97/eI1xNfE/f5vcthkpz8zuw91vkO+ZmXEU3sK9Ii+bHqutDK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210490; c=relaxed/simple;
	bh=5/2V1spGKRcRPV1ID8zq3T6K5dbltW7dZvw/bjWKbE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WZYxFXgAMk9Sjd0zKQz4TgcLSJ/g3P5iqvZckaQP1+O7JqGm7PtjMEKdVIuD+HQ8i6P6rEKtjYqaTYSfGSAHhg6rusdo337dW55rFLHWxpDG68+Q2vxSCitNPxvoReEGiQk9B+Hj3d0H4ENS99CqN7wFAbP/qqrieVmHys+Jdrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de; spf=pass smtp.mailfrom=plantwatch.de; dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b=b0d8t8nC; arc=none smtp.client-ip=185.139.157.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b="b0d8t8nC"
Received: from janus.uberspace.de (janus.uberspace.de [IPv6:2a0b:20c0:2000:62:be24:11ff:fe50:5107])
	by out02-fra1-mx.uberspace.de (Postfix) with ESMTPS id C64CEC042A;
	Thu, 16 Jul 2026 16:01:22 +0200 (CEST)
From: Simon Dietz <simon.dietz@plantwatch.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plantwatch.de;
	s=uberspace1; t=1784210477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tUMU/I5JmBksS4n4DsoBjhx3/vQjXtQb/Z+yQzT46k0=;
	b=b0d8t8nC5Fu8M5qSH0iILigcxH5FdjExRI8MpCdN+j7VxRIjzSUx8KNNiFQD7kPJPaEN+F
	TtRu9pSMJYjH2b8mwZ8aVKb2iCJKReu+2tFB5rtto1Gp0iRN/jUo4Onju15Eo7BdvKDtg+
	YhD/dUHvucvaN79OcChzTPdxS2skD5z3Y/Okq64/w41Ig88DR7xKtJB6xfIu/eYif9iK2B
	Adh5I6Y0NPblto0VFu7gcktdNwBhCR8lpm7siE/GyD2XPioj3iLXM8znmnOC44x5KvLtxJ
	0WLU69tJFHfowkdIG0gd5sdQkjBb9L4Rd8bNaShMSX9YK0Xvu4fKU6i5nS6EQA==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=simon.dietz@plantwatch.de smtp.mailfrom=simon.dietz@plantwatch.de
To: netdev@vger.kernel.org
Cc: edumazet@google.com,
	davem@davemloft.net,
	kuniyu@google.com,
	andrew+netdev@lunn.ch,
	simon.dietz@plantwatch.de,
	dietz23838@hs-ansbach.de,
	linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: [RFC PATCH net-next v0 0/6] net: add GeoNetworking protocol
Date: Thu, 16 Jul 2026 15:58:40 +0200
Message-ID: <20260716135902.2895237-1-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.56 / 999.00];
	BAYES_HAM(-2.34)[96.94%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	ASN_FAIL(0.00)[9.1.c.0.d.c.7.f.c.b.9.0.d.6.3.d.0.0.9.1.0.0.7.b.e.e.0.0.3.0.0.2.asn6.rspamd.com:query timed out];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	DKIM_SIGNED(0.00)[plantwatch.de:s=uberspace1];
	LOCAL_OUTBOUND(0.00)[]

Implement the GeoNetworking / ETSI ITS-G5 ('net/gn') protocol which
is based on 802.11p wifi and used for vehicle2x applications. It is
standardized by the ETSI and used by some car manufacturers
(especially in europe). It enables ad-hoc, multi-hop geographical
communication and routing among vehicles (and road- or railside
infrastructure).

Most work of this implementation has been done by the bachelor
project 2018/2019 of the operating systems and middleware group of
the Hasso Plattner Institute, University of Potsdam, which the author
was part of.

The project was supervised by:
- Jossekin Beilharz
- Lukas Pirl
- Prof. Andreas Polze

The code is published under the GPL v2 at this location:
https://gitlab.com/hpi-potsdam/osm/g5-on-linux/linux-geonetworking/

The original code base was based on linux version 5.1. The first patch
includes the original codebase rebased to the current net-next code
base so that it compiles under current net-next (as required by
submitting patch guidelines in order not to break git bisect). I've
backed up a not squashed version of this patch series if a more
compartmentalized history would be desired.

The subsequent patches address bounds, null, empty checks, memory
safety, locking, code style and ETSI standard conformity improvements.

This patch series is not merge-ready, yet. E.g. network namespaces are
not supported at all, documentation is missing, ...

Purpose of this RFC is to determine if GeoNetworking support in the
linux kernel is desirable and if so what steps would have to be done
next. There is ongoing research on the topic vehicle2x, which may
benefit from GeoNetworking support in the Linux kernel.

Sorry for the previous submission which was only partially transmitted

Greetings,
Simon

Simon Dietz (6):
  net: add GeoNetworking protocol
  net: fix GeoNetworking
  net: further fix GeoNetworking
  net: even further fix GeoNetworking
  net: add ppc64 support for GeoNetworking
  net: apply RCS to GeoNetworking

 include/linux/gn.h                  |  349 +++++
 include/linux/gn_routing.h          |   68 +
 include/linux/socket.h              |    6 +-
 include/uapi/linux/gn.h             |   84 ++
 include/uapi/linux/if_ether.h       |    1 +
 net/Kconfig                         |    2 +
 net/Makefile                        |    1 +
 net/gn/Kconfig                      |    4 +
 net/gn/Makefile                     |    8 +
 net/gn/gn_proc.c                    |   86 ++
 net/gn/gn_prot.c                    | 2012 +++++++++++++++++++++++++++
 net/gn/gn_routing.c                 |  632 +++++++++
 net/gn/sysctl_net_gn.c              |   33 +
 security/selinux/hooks.c            |    5 +-
 security/selinux/include/classmap.h |    3 +-
 15 files changed, 3290 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/gn.h
 create mode 100644 include/linux/gn_routing.h
 create mode 100644 include/uapi/linux/gn.h
 create mode 100644 net/gn/Kconfig
 create mode 100644 net/gn/Makefile
 create mode 100644 net/gn/gn_proc.c
 create mode 100644 net/gn/gn_prot.c
 create mode 100644 net/gn/gn_routing.c
 create mode 100644 net/gn/sysctl_net_gn.c

-- 
2.55.0

