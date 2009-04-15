Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDORR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 13:17:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Lu8kE-0002RQ-9v
	for linux-wireless@vger.kernel.org; Wed, 15 Apr 2009 19:17:54 +0200
Message-Id: <20090415171046.336006351@sipsolutions.net> (sfid-20090415_191800_425432_FA40D498)
Date: Wed, 15 Apr 2009 19:10:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/3] mac80211 powersave improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This series contains the following:

 1) improve powersave to only allow it when a single
    managed interface is active

 2) disable PS when the maximum networking latency
    applications are are willing to put up with is
    smaller than the beacon interval -- in that case
    we cannot allow the AP to buffer frames

 3) enable powersave by default

The last part might be controversial?

Should we have a default setting for the dynamic PS
timeout?

Oh also -- below is a small program to play with the
pm_qos framework, feel free to rip it for anything.

johannes

/*
 * Copyright 2009 Johannes Berg <johannes@sipsolutions.net>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *
 * Compile simply with:
 *	cc -o netlatency netlatency.c
 */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	int32_t v;
	int fd;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s <latency [us]>\n", argv[0]);
		fprintf(stderr, "\n");
		fprintf(stderr, "	latency: the maximum tolerable network latency you\n");
		fprintf(stderr, "	         are willing to put up with [in microseconds]\n");
		fprintf(stderr, "\n");
		fprintf(stderr, "This program will block until you hit Ctrl-C, at which point\n");
		fprintf(stderr, "the file descriptor is closed and the latency requirement is\n");
		fprintf(stderr, "unregistered again.\n");
		return 2;
	}

	v = atoi(argv[1]);

	printf("setting latency to %d.%.6d seconds\n", v/1000000, v % 1000000);

	fd = open("/dev/network_latency", O_WRONLY);
	if (fd < 0) {
		perror("open /dev/network_latency");
		return 1;
	}
	if (write(fd, &v, sizeof(v)) != sizeof(v)) {
		perror("write to /dev/network_latency");
		return 1;
	}

	while (1) sleep(10);

	return 0;
}

