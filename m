Received: from out02-fra1-mx.uberspace.de (out02-fra1-mx.uberspace.de [185.139.157.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CF71A0BE0;
	Sat, 18 Jul 2026 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.139.157.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784408617; cv=none; b=ItTb6jQu4fq9ZCEeemJDflHxm7bZH3MUeH7YBWRHatI7VUJFL5nLIkJSCu0AcV6eF6VrKHsW1cqCh2nbbcb+UBwplngOa3OQK3QuYgo8qJ/1dwEyV7DdvyjyY/fPnKf505kZ3Qm6gS3m05DA+gtNhbHvCLf8cz6eRYuSkwtGjmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784408617; c=relaxed/simple;
	bh=VckANWSJSbDp8WF4GvWn19eK+VZqN1+Vc6BshpWTd1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lht9p7aTZPv8u5whNC+RvWZsOIXzQGExDswUx+YMi0gJGJJ6Cg86ol7pihtO2rdN9fPB67Hv9PdGyht1J6qK0RRihWhtAklKoJHkNozlmykbK1zYU5CbTm83wUj2xIYGOk4k4kmicWqN6cgTByI2y8hPNepz1GJB20N+xW8jv9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de; spf=pass smtp.mailfrom=plantwatch.de; dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b=Exfuk9aQ; arc=none smtp.client-ip=185.139.157.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b="Exfuk9aQ"
Received: from janus.uberspace.de (janus.uberspace.de [IPv6:2a0b:20c0:2000:62:be24:11ff:fe50:5107])
	by out02-fra1-mx.uberspace.de (Postfix) with ESMTPS id CC869C00E9;
	Sat, 18 Jul 2026 23:03:20 +0200 (CEST)
From: Simon Dietz <simon.dietz@plantwatch.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plantwatch.de;
	s=uberspace1; t=1784408599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q5KCGS25M/mKrk1w8GgnzR5mL+po+UkU7f+oYxSYsHE=;
	b=Exfuk9aQxHnpDewKggseosyIA58/fkazdIakCnXIotitVNS3crOGLAuaEGLyMob85gI4uR
	jNzJNR3GJ2rl+rIuax98bJ98F2OzRg6Ctg5Z5dwn6G2JHEuJ6b7ZzgCTgVtFQ+sfTu+Qx7
	OV3ShMhZYT5F/t40EsbeKyJiYtDB513q2Wwd0wNJNtokWJr6IPzWvUJl+nWEq/gVNqtNPW
	BVMuOX9/3h9zKJpFwH2GF+P3VLJZQoqerFKkZqENjCVXrTlz4p7KCop7ZUanple2crVTBJ
	r0VwyJUcbomf0TOPpdNGloDskVuQkqFiXH+neJyJ6TQuX/+szKNvlwCt4hXoow==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=simon.dietz@plantwatch.de smtp.mailfrom=simon.dietz@plantwatch.de
To: netdev@vger.kernel.org
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	johannes@sipsolutions.net,
	kuniyu@google.com,
	linux-wireless@vger.kernel.org,
	simon.dietz@plantwatch.de,
	dietz23838@hs-ansbach.de
Subject: [RFC PATCH net-next v0.1 0/1] add GeoNetworking protocol
Date: Sat, 18 Jul 2026 23:00:32 +0200
Message-ID: <20260718210046.2357882-1-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [2.89 / 999.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.01)[51.21%];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:3320, ipnet:2003::/19, country:DE];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
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

The code [1] is published under the GPL v2 at this location:
https://gitlab.com/hpi-potsdam/osm/g5-on-linux/linux-geonetworking/

This patch set is not merge-ready, yet. E.g. network namespaces are
not supported at all, documentation is missing, ...

Purpose of this RFC is to determine if GeoNetworking support in the
linux kernel is desirable and if so what steps would have to be done
next.

In the original implementation new ioctl calls have been used. For the
removal of them and changing their functionality to use netlink (and
only this change) help of AI has been used as stated in the commit.

Changes since v0:
* replace ioctl interface changes with netlink
* remove profcs
* remove magic value in unix/ETSI epoch conversion
* add _HLEN macros
* remove inline from static functions
* remove commented out code
* change default log level to debug
* adhere to line limit of 80

Changes in v0:
* rebase to current-net next
* fix (most) of coding style violations
* fix SPDX-License Identifiers
* use kzalloc_obj instead of kzalloc
* change __attribute__((packed)) to __packed
* (partially?) fix locking
* adhere to kernel error code conventions
* add various bounds, 0, NULL, ... checks
* use has_for_each_safe
* refactor forward_packet helper functions
* document -EEXIST return on existing dev
* add gn_fill_depv and ls_flush logic
* add nexthop query logic
* replace timespec64 with uapi conform __kernel_timespec
* fix default hop limit

Detailed explaination of the changes:

net: gn: remove procfs

Remove any procfs usage for debugging purposes. Procfs has been used
during the development of the gn module for passing gps data from the
user space to the kernel. This behaviour has been changed to ioctl.
Procfs has only been kept for debugging reasons and is removed hereby.

net: gn: remove magic value in unix/ETSI epoc conversion

ETSI uses a different epoch than the unix default 1970-01-01 00:00:00.
For epoch conversion a magic value has been used, which now is replaced
by a constant.

net: gn: add _HLEN macros

Add _HLEN macros and use them to shorten code lines.

net: gn: remove inline from static functions
net: gn: remove commented out code
net: gn: change default log level to debug
net: gn: enforce line lenght limit of 80

For an explaination of changes in v0 compared to the original code base
[1] consult the patch series v0.

Greetings,
Simon

PS: The commit message date is off, because I squashed the commits.

Simon Dietz (1):
  net: add GeoNetworking protocol

 include/linux/gn.h                  |  363 +++++
 include/linux/gn_routing.h          |   68 +
 include/linux/socket.h              |    6 +-
 include/uapi/linux/gn.h             |   84 ++
 include/uapi/linux/if_ether.h       |    1 +
 include/uapi/linux/if_link.h        |   10 +
 net/Kconfig                         |    2 +
 net/Makefile                        |    1 +
 net/gn/Kconfig                      |    4 +
 net/gn/Makefile                     |    7 +
 net/gn/gn_netlink.c                 |  266 ++++
 net/gn/gn_prot.c                    | 1908 +++++++++++++++++++++++++++
 net/gn/gn_routing.c                 |  646 +++++++++
 net/gn/sysctl_net_gn.c              |   33 +
 security/selinux/hooks.c            |    5 +-
 security/selinux/include/classmap.h |    3 +-
 16 files changed, 3403 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/gn.h
 create mode 100644 include/linux/gn_routing.h
 create mode 100644 include/uapi/linux/gn.h
 create mode 100644 net/gn/Kconfig
 create mode 100644 net/gn/Makefile
 create mode 100644 net/gn/gn_netlink.c
 create mode 100644 net/gn/gn_prot.c
 create mode 100644 net/gn/gn_routing.c
 create mode 100644 net/gn/sysctl_net_gn.c

-- 
2.55.0

