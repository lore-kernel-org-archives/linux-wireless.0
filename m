Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZEEANK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 20:13:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1M18HV-00069X-Dp
	for linux-wireless@vger.kernel.org; Tue, 05 May 2009 02:13:09 +0200
Subject: virtual rfkill button
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 05 May 2009 02:12:33 +0200
Message-Id: <1241482353.8683.111.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just so I don't lose the code again ...

johannes

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <linux/uinput.h>

int main(int argc, char **argv)
{
	struct uinput_user_dev dev;
	struct input_event ev;
	int fd, ret;

	fd = open("/dev/input/uinput", O_WRONLY);
	if (fd < 0) {
		perror("open");
		if (errno == ENOENT)
			fprintf(stderr, "Try to \"modprobe uinput\".\n");
		return 1;
	}

	/* set up virtual device */
	memset(&dev, 0, sizeof(dev));
	strcpy(dev.name, "virt-rfkill");

	ioctl(fd, UI_SET_EVBIT, EV_KEY);
	ioctl(fd, UI_SET_KEYBIT, KEY_WLAN);

	ret = write(fd, &dev, sizeof(dev));
	if (ret != sizeof(dev)) {
		perror("write setup");
		return 1;
	}

	/* register device */
	ret = ioctl(fd, UI_DEV_CREATE);
	if (ret) {
		perror("create");
		return 1;
	}

	/* write event */
	memset(&ev, 0, sizeof(ev));
	ev.type = EV_KEY;
	ev.code = KEY_WLAN;
	ret = write(fd, &ev, sizeof(ev));
	if (ret != sizeof(ev)) {
		perror("write event");
		return 1;
	}

	return 0;
}


